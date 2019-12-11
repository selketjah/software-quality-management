module metrics::Duplicates
import lang::java::jdt::m3::Core;
import lang::java::m3::AST;
import IO;
import Set;
import Map;
import Node;
import Prelude;

alias Sequence  = list[node];
alias Sequences = list[Sequence];
data ClonePair  = sequence(Sequence origin, Sequence clone);
alias TypedPairs = map[str, ClonePairs];
alias ClonePairs = map[set[int], ClonePair];
alias SequenceBuckets = map[str, Sequences];
SequenceBuckets newSequenceBuckets() = ();

private map[int childOf, node parent] childrenToParent = ();
alias UniqueDeclaration = tuple[int id, Declaration subTree];
alias UniqueStatement = tuple[int id, Statement subTree];
private map[int id, UniqueDeclaration ud] astDeclarationIdentifiers = ();
private map[int id, UniqueStatement us] astStatementIdentifiers = ();
anno int node @ uniqueKey;

public str getSeqFingerprint(Sequence seq) {
    return ("" | it + getFingerprint(st) | st <- seq);
}

public set[str] getSeqFingerprintAsSet(Sequence seq) {
    return {getFingerprint(st) | st <- seq};
}

public str getFingerprint(node tree) = getCachedFingerprint(tree) when isFingerprintCached(tree);

public str getFingerprint(node tree) {

    // remove annotations because it makes it too perfect.
    cleanNode = delAnnotationsRec(tree);
    
    fingerprint = toString(cleanNode);
    
    addFingerprintCache(tree, fingerprint);
    
    // get node as string
    return fingerprint;
}

public ClonePairs detectClones(list[loc] fileLocations){
	set[Declaration] asts = {};
	for(loc fileLoc <- fileLocations){
		
		asts = asts + createAstFromFile(|project://Jabberpoint-le3/src/AboutBox.java|, false);
		
	}
	
	asts = putIdentifiers(asts);
	return detectClones(6);
}

public ClonePairs detectClones(int minSequenceLength){
	collectChildrenToParentIndexFromAST();
    clonesSeqs = detectSequenceClones(minSequenceLength, getSeqFingerprint);
    return generalizeClones(clonesSeqs, areParentsEqual);
}

void collectChildrenToParentIndexFromAST() {
	for(int id <- astStatementIdentifiers){
		println(id);
		setChildrenFromAParent(astStatementIdentifiers[id]);
	}
	
	for(int id<- astStatementIdentifiers){
		setChildrenFromAParent(astStatementIdentifiers[id]);
	}
}
private void setChildrenFromAParent(UniqueDeclaration subTree) {
	int parentUniqueKey = subTree.id;
    
    setChildrenFromParent(parentUniqueKey, subTree.subTree);
}
private void setChildrenFromAParent(UniqueStatement subTree) {
	
    int parentUniqueKey = subTree.id;
    
    setChildrenFromParent(parentUniqueKey, subTree.subTree);
}

private void setChildrenFromParent(parentUniqueKey, subTree){
	allChildrenNodes = getChildren(subTree);
    return;
    for (child <- allChildrenNodes) {
        switch (child) {
            case Statement statement: {
            	println(statement);
            	childrenToParent[statement@uniqueKey] = subTree;
            }
            case Declaration declaration: childrenToParent[declaration@uniqueKey] = subTree;
            case list[Statement] block: {
                        	println(block);
            
                for (statement <- block) {
                    childrenToParent[statement@uniqueKey] = subTree.subTree;
                }
            }
            case list[Declaration] declarations: {
                for (declaration <- declarations) {
                    childrenToParent[declaration@uniqueKey] = subTree.subTree;
                }
            }
            default:
            	println(child);
        }
    }
}

Sequences extractSequencesFromAST(minSequenceLength) {
    
    Sequences sequences = [];
    set[Declaration] asts = {declId.subTree |declId <-  range(astDeclarationIdentifiers)};
    
    bottom-up visit (asts) {
        case list[Statement] sequence: {
            if (size(sequence) >= minSequenceLength) {
                sequences += [sequence];
            }
        }
    }    
    return sequences;
}
int getLargestSequenceSize([])  = 0;
int getLargestSequenceSize(Sequences sequences) {
    return max([size(sequence) | sequence <- sequences]);
}

ClonePairs newClonePairs() = ();

Sequences getSubSequences([], _) = [];
Sequences getSubSequences(Sequence sequence, int length) throws IllegalArgument {
    if (length > size(sequence)) {
        throw IllegalArgument("Length cannot be more than the size of the sequence");
    }
    
    return [
        subSequence | 
        \start <- [0..size(sequence)], 
        subSequence := sequence[\start .. (\start + length)], 
        size(subSequence) == length
    ];
}

Sequences getSubSequences(Sequence sequence, int length) = [sequence] when length == size(sequence);
Sequences getSubSequences(Sequences sequences, int length) {
    return ([] | it + getSubSequences(sequence, length) | sequence <- sequences, size(sequence) >= length);
}

SequenceBuckets constructSequenceBuckets(Sequences subSequences, str (Sequence) fingerprinter) {

    SequenceBuckets sequenceBuckets = newSequenceBuckets();
    Sequences emptySequences = [];
    
    for (subSequence <- subSequences) {
        str fingerprint = fingerprinter(subSequence);
        sequenceBuckets[fingerprint] ? emptySequences += [subSequence];
    }
    
    return sequenceBuckets;
}

ClonePairs removeSequenceSubclones(Sequence origin, Sequence clone, ClonePairs clones) {
    originKeys = getSequenceUniqueKeys(origin);
    cloneKeys  = getSequenceUniqueKeys(clone);
    
    allKeys = originKeys + cloneKeys;
    
    for (hashKeys <- clones, allKeys > hashKeys) {
        clones = delete(clones, hashKeys);
    }
    
    return clones;
}

ClonePairs addClonePair(Sequence origin, Sequence clone, ClonePairs clones) {
    clones[getSequenceUniqueKeys(origin)] = sequence(origin, clone);
    return clones;
}

ClonePairs detectSequenceClones(int minSequenceLength, str (Sequence) fingerprinter) {

    Sequences allSequences = extractSequencesFromAST(minSequenceLength);
    
    // * For k = MinimumSequenceLengthThreshold to MaximumSequenceLength
    int maximumSequenceLength = getLargestSequenceSize(allSequences);
    ClonePairs cloneSequencePairs = newClonePairs();
    
    sequenceLengths = [minSequenceLength .. (maximumSequenceLength + 1)];
    
    for (sequenceLength <- sequenceLengths) {
        
        // * Place all subsequences of length (sequenceLength) into buckets according to subsequence hash
        Sequences subSequences = getSubSequences(allSequences, sequenceLength);
        SequenceBuckets sequenceBuckets = constructSequenceBuckets(subSequences, fingerprinter);
                
        for (bucketHash <- sequenceBuckets) {
            
            sequencesIndeces = index(sequenceBuckets[bucketHash]);

            // * For each subsequence i and j in same bucket
            for (originSeqIndex <- sequencesIndeces,
                cloneSeqIndex <- sequencesIndeces,
                originSeqIndex != cloneSeqIndex)
            {
                Sequence originSubSeq = sequenceBuckets[bucketHash][originSeqIndex];
                Sequence cloneSubSeq = sequenceBuckets[bucketHash][cloneSeqIndex];

                if (!isOverlap(originSubSeq, cloneSubSeq)) {
                    
                    // * RemoveSequenceSubclonesOf(clones, i, j, k)
                    cloneSequencePairs = removeSequenceSubclones(originSubSeq, cloneSubSeq, cloneSequencePairs);
    
                    // * AddSequenceClonePair(Clones, i, j, k)
                    cloneSequencePairs = addClonePair(originSubSeq, cloneSubSeq, cloneSequencePairs);
                }
            }
        }
    }
    
    return cloneSequencePairs;
}

private bool isOverlap(Sequence origin, Sequence clone) = getSequenceUniqueKeys(origin) & getSequenceUniqueKeys(clone) != {};

&E putIdentifiers(&E ast) = putIdentifiers(ast, 0);

&E putIdentifiers(&E ast, int \start) {
    counter = \start;
    return visit (ast) {
        case Statement subTree: {
            counter += 1;
            println("UNIQUE IDENTIFIER FOR AST <counter> STMT");
            getStatementUID(subTree);
            astStatementIdentifiers[counter]=<counter, subTree>;;
            
            
            insert subTree;
        }
        case Declaration subTree: {
            counter += 1;
            astDeclarationIdentifiers[counter]=<counter, subTree>;
            
            insert subTree;
        }
    }
}

str getStatementUID(Statement stmt){
	visit(stmt){
		case \simpleName(name, src):println(name);
	}
	
	return "test";
}

private bool areParentsEqual(node treeA, node treeB) = treeA == treeB;

ClonePairs generalizeClones(ClonePairs clones, bool (node, node) areParentsEqual) {
    
    // * 1. ClonesToGeneralize = Clones
    ClonePairs clonesToGeneralize = clones;
    
   
    // * 2. While ClonesToGeneralize≠∅
    while (true) {
        
        if (size(clonesToGeneralize) == 0) break;
        
        
        currentKey = toList(domain(clonesToGeneralize))[0];
        ClonePair pair = clonesToGeneralize[currentKey];
        
        // * 3. Remove clone(i,j) from ClonesToGeneralize
        clonesToGeneralize = delete(clonesToGeneralize, currentKey);
        
        if (!hasParent(pair.origin)) {
            continue;
        }
        
        // * 4. If CompareClones(ParentOf(i), ParentOf(j)) > SimilarityThreshold
        parentOfOrigin = getParentOf(pair.origin);
        parentOfClone = getParentOf(pair.clone);
        
        if (parentOfOrigin@uniqueKey != parentOfClone@uniqueKey && areParentsEqual(parentOfOrigin, parentOfClone)) {
        
            // * 5. RemoveClonePair(Clones,i,j)
            clones = removeCloneFromClonePairs(pair.origin, clones);
            clones = removeCloneFromClonePairs(pair.clone, clones);
            
            // * 6. AddClonePair(Clones, ParentOf(i), ParentOf(j))
            clones = addClonePair(parentOfOrigin, parentOfClone, clones); 
            
            // * 7. AddClonePair(ClonesToGeneralize, ParentOf(i),ParentOf(j))
            clonesToGeneralize = addClonePair(parentOfOrigin, parentOfClone, clonesToGeneralize);
       }
    }
    

    return clones;
}
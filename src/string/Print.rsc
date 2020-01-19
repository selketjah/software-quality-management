module string::Print

import IO;
import String;
import List;
import Map;

import scoring::Rank;
import scoring::Ranking;
import scoring::Average;
import scoring::Percentage;
import scoring::Maintainability;

import structs::Volume;
import structs::Average;
import structs::Percentage;
import structs::UnitTestCoverage;
import structs::Ranking;
import structs::Maintainability;
import structs::Rank;

// Constants
int SCORE_FILL_UP_AMOUNT = 15;
int RANK_FILL_UP_AMOUNT = 5;

private str renderCategoryLegendTables() {
	return("
		'**********************************************************************************
		' Volume:
		'
		' Rank Levels:
		' --------------------
		' | Rank | KLOC      |
		' --------------------
		' | ++   | 0-66      |
		' | +    | 66-246    |
		' | o    | 246-665   |
		' | -    | 655-1,310 |
		' | --   | \>1,310   |
		' --------------------
		'
		'
		'
		' Unit Size:
		'
		' Risk Levels:
		' -------------------------------------------
		' | LOC   | Risk Evaluation                 |
		' -------------------------------------------
		' | \>0    | without much risk, simple risk |
		' | \>30   | more complex, moderate risk    |
		' | \>44   | complex, high risk             |
		' | \>74   | untestable, very high risk     |
		' -------------------------------------------
		'
		' Rank Levels (Maximum relative LOC):
		' --------------------------------------
		' | Rank | Moderate | High | Very High |
		' --------------------------------------
		' | ++   | 25%      | 0%   | 0%        |
		' | +    | 30%      | 5%   | 0%        |
		' | o    | 40%      | 10%  | 0%        |
		' | -    | 50%      | 15%  | 5%        |
		' | --   | –        | –    | –         |
		' --------------------------------------
		'
		'
		'
		' Unit Complexity:
		'
		' Risk Levels:
		' ------------------------------------------
		' | CC    | Risk Evaluation                |
		' ------------------------------------------
		' | 1-10  | without much risk, simple risk |
		' | 11-20 | more complex, moderate risk    |
		' | 21-50 | complex, high risk             |
		' | \>50  | untestable, very high risk     |
		' ------------------------------------------
		'
		' Rank Levels (Maximum relative LOC):
		' --------------------------------------
		' | Rank | Moderate | High | Very High |
		' --------------------------------------
		' | ++   | 25%      | 0%   | 0%        |
		' | +    | 30%      | 5%   | 0%        |
		' | o    | 40%      | 10%  | 0%        |
		' | -    | 50%      | 15%  | 5%        |
		' | --   | –        | –    | –         |
		' --------------------------------------
		'
		'
		'
		' Duplication:
		'
		' Rank Levels:
		' ---------------------------------
		' | Rank | Duplication Percentage |
		' ---------------------------------
		' | ++   | 0-3%                   |
		' | +    | 3-5%                   |
		' | o    | 5-10%                  |
		' | -    | 10-20%                 |
		' | --   | 20-100%                |
		' ---------------------------------
		'
		'
		' Unit test coverage:
		'
		' Rank Levels:
		' ----------------------------------------
		' | Rank | Unit test coverage Percentage |
		' ----------------------------------------
		' | ++   | 95-100%                       |
		' | +    | 80-95%                        |
		' | o    | 60-80%                        |
		' | -    | 20-80%                        |
		' | --   | 0-20%                         |
		' ----------------------------------------
		'
		'
		' Maintainability Aspects (Simple Average):
		' -------------------------------------------------------------------------------------
		' | Aspects       | Volume | Unit Complexity | Duplication | Unit Size | Unit testing |
		' -------------------------------------------------------------------------------------
		' | Analysability |   X    |                 |      X      |     X     |      X       |
		' | Changeability |        |        X        |      X      |           |              |
		' | Stability     |        |                 |             |           |      X       |
		' | Testability   |        |        X        |             |     X     |      X       |
		' -------------------------------------------------------------------------------------
		'**********************************************************************************
	");
}

private str renderMaintainability(map[MaintainabilityCharacteristic characteristics, Rank ranks] maintainabilityCharacteristics) {
	maintainabilityCharacteristicPrintOut = "\n";
	for (maintainabilityCharacteristic <- maintainabilityCharacteristics.characteristics) {
		rank = maintainabilityCharacteristics[maintainabilityCharacteristic];
		maintainabilityCharacteristicPrintOut += "<convertMaintainabilityCharacteristicToLiteral(maintainabilityCharacteristic)>: <convertRankToLiteral(rank)>\n";
	}
	return maintainabilityCharacteristicPrintOut;
}

private str fillUp(str string, int amount) {
	iterations = amount - size(string);
	if (iterations <= 0) return string;
	for (_ <- [0..iterations]) string += " ";
	return string;
}

private str renderRanking(Ranks ranks) {
	return ("
		'**************************************************
		'
		'-----------------------------------------------
		'| Category           | <fillUp("Rank", RANK_FILL_UP_AMOUNT)> |
		'-----------------------------------------------
		'| Volume             | <fillUp(convertRankToLiteral(ranks.volume), RANK_FILL_UP_AMOUNT)> |
		'| Unit Complexity    | <fillUp(convertRankToLiteral(ranks.complexity), RANK_FILL_UP_AMOUNT)> |
		'| Duplication        | <fillUp(convertRankToLiteral(ranks.duplication), RANK_FILL_UP_AMOUNT)> |
		'| Unit Size          | <fillUp(convertRankToLiteral(ranks.unitSize), RANK_FILL_UP_AMOUNT)> |
		'| Unit test coverage | <fillUp(convertRankToLiteral(ranks.unitTestCoverage), RANK_FILL_UP_AMOUNT)> |
		'-----------------------------------------------
		'
		'Maintainability Aspects:
		'<renderMaintainability(ranks.maintainability)>
		'
		'Overall Rank: <convertRankToLiteral(ranks.overall)>
		'
		'
		'**************************************************
	");
}

private str renderStatistics(int volume, int numberOfUnits, Percentages percentages, Average averages) {
	return ("
		'**************************************************
		'
		'Lines of code: <volume>
		'Nuber of units: <numberOfUnits>
		'Average unit size: <averages.size>
		'Average complexity: <averages.complexity>
		'Duplication: <percentages.duplication>%
		'Unit test coverage: <percentages.unitTestCoverage>%
		'
		'**************************************************
	");
}

public void printResult(int volume, int numberOfUnits, Percentages percentages, Average averages, Ranks ranks) {
	println("Category Legends:\n<renderCategoryLegendTables()>\n");
	println("\nStatistics:");
	println("\n<renderStatistics(volume, numberOfUnits, percentages, averages)>\n");
	println("\nMaintainability Reports:");
	println("\n<renderRanking(ranks)>\n");	
}
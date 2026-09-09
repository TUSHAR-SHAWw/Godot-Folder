class_name FloorTypes
extends Node

enum Category { COMMON, DANGEROUS, SPECIAL, LEGENDARY }

const TYPES = {
	"SimpleFloor": Category.COMMON,
	"ForestFloor": Category.COMMON,
	"WaterFloor": Category.COMMON,
	"CaveFloor": Category.COMMON,
	"LavaFloor": Category.DANGEROUS,
	"ToxicFloor": Category.DANGEROUS,
	"IceFloor": Category.DANGEROUS,
	"ArmoryFloor": Category.SPECIAL,
	"FeastFloor": Category.SPECIAL,
	"MedicalFloor": Category.SPECIAL,
	"BlackMarketFloor": Category.SPECIAL,
	"LaboratoryFloor": Category.SPECIAL,
	"GoldenFloor": Category.LEGENDARY,
	"BossFloor": Category.LEGENDARY,
	"SanctuaryFloor": Category.LEGENDARY
}

PrefabFiles = {
    "starsword",
    "mightyarmor",
    "mightyhelmet",
    "scythe",
    "golden_scythe",
    "ancient_soul",
    "ancient_gem",
    "maxwelllight",
    "ydj_dst_td1madao_air_sword",
}

local Ingredient = GLOBAL.Ingredient
local RECIPETABS = GLOBAL.RECIPETABS
local TECH = GLOBAL.TECH

GLOBAL.STRINGS.NAMES.ANCIENT_GEM="逝者的灵魂的部分一"
GLOBAL.STRINGS.CHARACTERS.GENERIC.ANCIENT_GEM ="逝者的灵魂的部分一"
GLOBAL.STRINGS.RECIPE_ANCIENT_GEM= "逝者的灵魂的部分一"
GLOBAL.STRINGS.RECIPE_DESC.ANCIENT_GEM= "逝者的灵魂的部分一"
local ancient_gem = Recipe("ancient_gem", {Ingredient("nightmarefuel", 1), Ingredient("ash", 1)}, RECIPETABS.WAR, TECH.ONE)
ancient_gem.atlas = "images/inventoryimages/ancient_gem.xml"

GLOBAL.STRINGS.NAMES.ANCIENT_SOUL="逝者的灵魂的部分二"
GLOBAL.STRINGS.CHARACTERS.GENERIC.ANCIENT_SOUL ="逝者的灵魂的部分二"
GLOBAL.STRINGS.RECIPE_ANCIENT_SOUL= "逝者的灵魂的部分二"
GLOBAL.STRINGS.RECIPE_DESC.ANCIENT_SOUL= "逝者的灵魂的部分二"
local ancient_soul = Recipe("ancient_soul", {Ingredient("goldnugget", 1), Ingredient("nightmarefuel", 1)}, RECIPETABS.WAR, TECH.ONE)
ancient_soul.atlas = "images/inventoryimages/ancient_soul.xml"

GLOBAL.STRINGS.NAMES.STARSWORD="德行"
GLOBAL.STRINGS.CHARACTERS.GENERIC.STARSWORD ="斩星剑"
GLOBAL.STRINGS.RECIPE_STARSWORD= "德行"
GLOBAL.STRINGS.RECIPE_DESC.STARSWORD= "伤害随机"
local starsword = Recipe("starsword", {Ingredient("ancient_gem", 2), Ingredient("tentaclespike", 2), Ingredient("livinglog", 2)}, RECIPETABS.WAR, TECH.ONE)
starsword.atlas = "images/inventoryimages/starsword.xml"

GLOBAL.STRINGS.NAMES.MIGHTYARMOR="将军的盔甲"
GLOBAL.STRINGS.CHARACTERS.GENERIC.MIGHTYARMOR ="万战盔甲"
GLOBAL.STRINGS.RECIPE_DESC.MIGHTYARMOR= "用部分灵魂弥补"
local mightyarmor = Recipe("mightyarmor", {Ingredient("livinglog", 2), Ingredient("ancient_soul", 1), Ingredient("tentaclespots", 1)}, RECIPETABS.WAR, TECH.ONE)
mightyarmor.atlas = "images/inventoryimages/mightyarmor.xml"

GLOBAL.STRINGS.NAMES.MIGHTYHELMET="强壮的头盔"
GLOBAL.STRINGS.CHARACTERS.GENERIC.MIGHTYHELMET ="防雨又可以挨打的头盔"
GLOBAL.STRINGS.RECIPE_DESC.MIGHTYHELMET= "强壮的头盔"
local mightyhelmet = Recipe("mightyhelmet", {Ingredient("livinglog", 2), Ingredient("deerclops_eyeball", 1), Ingredient("ancient_gem", 2)}, RECIPETABS.WAR, TECH.ONE)
mightyhelmet.atlas = "images/inventoryimages/mightyhelmet.xml"

GLOBAL.STRINGS.NAMES.SCYTHE="全功能工具"
GLOBAL.STRINGS.CHARACTERS.GENERIC.SCYTHE ="全功能工具"
GLOBAL.STRINGS.RECIPE_SCYTHE= "全功能工具"
GLOBAL.STRINGS.RECIPE_DESC.SCYTHE= "可以采矿，砍树，当铲子用"
local scythe = Recipe("scythe", {Ingredient("axe", 1), Ingredient("pickaxe", 1), Ingredient("shovel", 1)}, RECIPETABS.WAR, TECH.ONE)
scythe.atlas = "images/inventoryimages/scythe.xml"

-- GLOBAL.STRINGS.NAMES.MAXWELLLIGHT="麦斯威尔之光"
-- GLOBAL.STRINGS.CHARACTERS.GENERIC.MAXWELLLIGHT ="麦斯威尔之光"
-- GLOBAL.STRINGS.RECIPE_MAXWELLLIGHT= "麦斯威尔之光"
-- GLOBAL.STRINGS.RECIPE_DESC.MAXWELLLIGHT= "麦斯威尔之光"
-- local scythe = Recipe("maxwelllight", {Ingredient("axe", 1), Ingredient("pickaxe", 1), Ingredient("shovel", 1)}, RECIPETABS.WAR, TECH.ONE)

GLOBAL.STRINGS.NAMES.GOLD_SCYTHE="全功能工具"
GLOBAL.STRINGS.CHARACTERS.GENERIC.GOLD_SCYTHE ="全功能工具"
GLOBAL.STRINGS.RECIPE_GOLD_SCYTHE= "全功能工具"
GLOBAL.STRINGS.RECIPE_DESC.GOLDSCYTHE= "可以采矿，砍树，当铲子用"
local golden_scythe = Recipe("golden_scythe", {Ingredient("goldenaxe", 1), Ingredient("goldenpickaxe", 1), Ingredient("goldenshovel", 1), Ingredient("cane", 1)}, RECIPETABS.WAR, TECH.ONE)
golden_scythe.atlas = "images/inventoryimages/golden_scythe.xml"
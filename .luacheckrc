-- luacheck para IconosRaton (Lua 5.1). Que cada API exista de verdad en Forever lo comprueba api_forever.py.
std = "lua51"
max_line_length = 160
exclude_files = { "tests/", "docs/", ".luacheckrc" }

-- Globales que el addon crea o modifica.
globals = {
    "IconosRatonDB",
    "IconosRaton_Compartimento",
    "IconosRaton_TextoConIcono",
}

-- API de WoW que el addon lee.
read_globals = {
    "C_Timer",
    "CreateFrame",
    "GetBindingKey",
    "GetBindingText",
    "GetLocale",
    "hooksecurefunc",
    "InCombatLockdown",
    "MinimalSliderWithSteppersMixin",
    "Settings",
    "_G",
}

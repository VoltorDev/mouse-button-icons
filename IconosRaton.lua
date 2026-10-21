-- IconosRaton: sustituye el texto de los botones del ratón en el atajo de cada botón de acción
-- por un icono del ratón con el botón resaltado. Solo cambia lo que se ve; no toca los atajos.
-- Opciones (Opciones.lua, IconosRatonDB): activado y tamaño de los iconos.
local _, ns = ...

local RUTA = "Interface\\AddOns\\IconosRaton\\media\\"

-- Vista lateral (vertical, 1:2, con la punta arriba) para los botones del pulgar; vista superior
-- (cuadrada) para los de arriba. BUTTON4 = atrás (G4), BUTTON5 = adelante (G5), BUTTON3 = rueda.
-- F10-F12 son las teclas que el perfil de WoW de G HUB envía con G6 (diana), G7 y G8.
local LATERAL = { ancho = 11, alto = 22 } -- en píxeles de interfaz
local SUPERIOR = { ancho = 20, alto = 20 }
local ICONOS = {
	BUTTON4 = { "boton4", LATERAL },
	BUTTON5 = { "boton5", LATERAL },
	F10 = { "g6", LATERAL },
	BUTTON3 = { "boton3", SUPERIOR },
	F11 = { "g7", SUPERIOR },
	F12 = { "g8", SUPERIOR },
}

local MODIFICADORES = {
	{ "SHIFT%-", "S" },
	{ "CTRL%-", "C" },
	{ "ALT%-", "A" },
	{ "META%-", "M" },
}

-- Barras de Blizzard (misma lista que ActionButtonUtil.ActionBarButtonNames).
local BARRAS = {
	"ActionButton",
	"MultiBarBottomLeftButton",
	"MultiBarBottomRightButton",
	"MultiBarLeftButton",
	"MultiBarRightButton",
	"MultiBar5Button",
	"MultiBar6Button",
	"MultiBar7Button",
}

local DEFECTO = { activado = true, tamano = 1 }

-- Opciones guardadas, con los valores por defecto que falten.
function ns.Opciones()
	IconosRatonDB = type(IconosRatonDB) == "table" and IconosRatonDB or {}
	for clave, valor in pairs(DEFECTO) do
		if IconosRatonDB[clave] == nil then
			IconosRatonDB[clave] = valor
		end
	end
	return IconosRatonDB
end
ns.DEFECTO = DEFECTO

-- Devuelve el texto con icono para una tecla como "SHIFT-BUTTON4", o nil si no es un botón del ratón.
-- tamano multiplica el tamaño del icono (1 por defecto).
local function TextoConIcono(tecla, tamano)
	if type(tecla) ~= "string" then
		return nil
	end
	local resto, prefijo = tecla, ""
	-- WoW los escribe como ALT-CTRL-SHIFT-…; se quitan del principio en el orden en que vengan.
	local quitado = true
	while quitado do
		quitado = false
		for _, m in ipairs(MODIFICADORES) do
			local sin, n = resto:gsub("^" .. m[1], "")
			if n > 0 then
				resto = sin
				prefijo = prefijo .. m[2] .. "+"
				quitado = true
			end
		end
	end
	local icono = ICONOS[resto]
	if not icono then
		return nil
	end
	local vista, factor = icono[2], tamano or 1
	local alto, ancho = math.floor(vista.alto * factor + 0.5), math.floor(vista.ancho * factor + 0.5)
	return prefijo .. "|T" .. RUTA .. icono[1] .. ":" .. alto .. ":" .. ancho .. "|t"
end

local function Actualizar(boton)
	local hotkey = boton.HotKey
	if not hotkey or not boton.bindingAction then
		return
	end
	local tecla = GetBindingKey(boton.bindingAction)
		or GetBindingKey("CLICK " .. boton:GetName() .. ":LeftButton")
	local opciones = ns.Opciones()
	local texto = TextoConIcono(tecla, opciones.tamano)
	if not texto then
		return
	end
	if opciones.activado then
		hotkey:SetText(texto)
	else
		hotkey:SetText(GetBindingText(tecla, true)) -- el texto de Blizzard («S-Botón 4»)
	end
	hotkey:Show()
end

local enganchados = {}

local function EngancharTodo()
	for _, base in ipairs(BARRAS) do
		for i = 1, 12 do
			local boton = _G[base .. i]
			if boton and boton.UpdateHotkeys then
				if not enganchados[boton] then
					hooksecurefunc(boton, "UpdateHotkeys", Actualizar)
					enganchados[boton] = true
				end
				Actualizar(boton)
			end
		end
	end
end

ns.EngancharTodo = EngancharTodo

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("UPDATE_BINDINGS")
f:SetScript("OnEvent", function()
	-- Blizzard repinta los atajos en el mismo evento; se repasa al siguiente frame para ir detrás.
	C_Timer.After(0, EngancharTodo)
end)

-- Expuesto para pruebas fuera del juego.
IconosRaton_TextoConIcono = TextoConIcono

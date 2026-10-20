-- IconosRaton: sustituye el texto de los botones del ratón en el atajo de cada botón de acción
-- por un icono del ratón con el botón resaltado. Solo cambia lo que se ve; no toca los atajos.

local RUTA = "Interface\\AddOns\\IconosRaton\\media\\"
local TAM = 14 -- alto y ancho del icono, en píxeles de interfaz

-- BUTTON4 = atrás (G4), BUTTON5 = adelante (G5), BUTTON3 = rueda.
local ICONOS = {
	BUTTON3 = RUTA .. "boton3",
	BUTTON4 = RUTA .. "boton4",
	BUTTON5 = RUTA .. "boton5",
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

-- Devuelve el texto con icono para una tecla como "SHIFT-BUTTON4", o nil si no es un botón del ratón.
local function TextoConIcono(tecla)
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
	return prefijo .. "|T" .. icono .. ":" .. TAM .. ":" .. TAM .. "|t"
end

local function Actualizar(boton)
	local hotkey = boton.HotKey
	if not hotkey or not boton.bindingAction then
		return
	end
	local tecla = GetBindingKey(boton.bindingAction)
		or GetBindingKey("CLICK " .. boton:GetName() .. ":LeftButton")
	local texto = TextoConIcono(tecla)
	if texto then
		hotkey:SetText(texto)
		hotkey:Show()
	end
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

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("UPDATE_BINDINGS")
f:SetScript("OnEvent", function()
	-- Blizzard repinta los atajos en el mismo evento; se repasa al siguiente frame para ir detrás.
	C_Timer.After(0, EngancharTodo)
end)

-- Expuesto para pruebas fuera del juego.
IconosRaton_TextoConIcono = TextoConIcono

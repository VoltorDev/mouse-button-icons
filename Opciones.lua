-- Menú en Opciones > AddOns > IconosRaton con la API nativa Settings: activar los iconos, su tamaño y
-- F10-F12 como G6-G8. Textos en inglés, y en español con el cliente en esES o esMX.
-- Cada cambio repinta los atajos de las barras en el acto. Se registra en PLAYER_LOGIN, con IconosRatonDB
-- ya cargada.
local _, ns = ...

local categoria

local ES = GetLocale() == "esES" or GetLocale() == "esMX"
local T = ES
		and {
			activado = "Iconos del ratón en los atajos",
			activadoAyuda = "Enseña un icono del ratón en lugar de «Botón 4/5» en las barras de acción. Apagado, vuelve el texto de Blizzard.",
			tamano = "Tamaño de los iconos",
			tamanoAyuda = "Tamaño de los iconos respecto al normal.",
			ghub = "F10, F11 y F12 como G6, G7 y G8",
			ghubAyuda = "Para un Logitech G502 con G HUB enviando F10-F12 desde G6 (diana), G7 y G8: dibuja esas teclas como botones del ratón.",
		}
	or {
		activado = "Mouse icons on keybinds",
		activadoAyuda = "Shows a mouse icon instead of “Mouse Button 4/5” on the action bars. Off, Blizzard’s text is back.",
		tamano = "Icon size",
		tamanoAyuda = "Icon size relative to normal.",
		ghub = "F10, F11 and F12 as G6, G7 and G8",
		ghubAyuda = "For a Logitech G502 with G HUB sending F10-F12 from G6 (sniper), G7 and G8: draws those keys as mouse buttons.",
	}

local function Repintar()
	ns.EngancharTodo()
end

local function Crear()
	local opciones = ns.Opciones()
	categoria = Settings.RegisterVerticalLayoutCategory("IconosRaton")

	local activado = Settings.RegisterAddOnSetting(
		categoria,
		"IconosRaton_Activado",
		"activado",
		opciones,
		Settings.VarType.Boolean,
		T.activado,
		ns.DEFECTO.activado
	)
	activado:SetValueChangedCallback(Repintar)
	Settings.CreateCheckbox(categoria, activado, T.activadoAyuda)

	local tamano = Settings.RegisterAddOnSetting(
		categoria,
		"IconosRaton_Tamano",
		"tamano",
		opciones,
		Settings.VarType.Number,
		T.tamano,
		ns.DEFECTO.tamano
	)
	tamano:SetValueChangedCallback(Repintar)
	local deslizador = Settings.CreateSliderOptions(0.6, 1.6, 0.1)
	deslizador:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right, function(valor)
		return ("%d %%"):format(math.floor(valor * 100 + 0.5))
	end)
	Settings.CreateSlider(categoria, tamano, deslizador, T.tamanoAyuda)

	local ghub = Settings.RegisterAddOnSetting(
		categoria,
		"IconosRaton_TeclasGHub",
		"teclasGHub",
		opciones,
		Settings.VarType.Boolean,
		T.ghub,
		ns.DEFECTO.teclasGHub
	)
	ghub:SetValueChangedCallback(Repintar)
	Settings.CreateCheckbox(categoria, ghub, T.ghubAyuda)

	Settings.RegisterAddOnCategory(categoria)
end

-- Compartimento de addons (junto al minimapa): el nombre coincide con el TOC. Abrir Opciones está
-- restringido en combate.
function IconosRaton_Compartimento()
	if categoria and not InCombatLockdown() then
		Settings.OpenToCategory(categoria:GetID())
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function(self)
	self:UnregisterAllEvents()
	Crear()
end)

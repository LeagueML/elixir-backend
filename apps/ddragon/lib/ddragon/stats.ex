defmodule Ddragon.Stats do
  defstruct [
    :hp,
    :hp_per_level,
    :mp,
    :mp_per_level,
    :movespeed,
    :armor,
    :armor_per_level,
    :spellblock,
    :spellblock_per_level,
    :attackrange,
    :hp_regen,
    :hp_regen_per_level,
    :mp_regen,
    :mp_regen_per_level,
    :crit,
    :crit_per_level,
    :attack_damage,
    :attack_damage_per_level,
    :attackspeed,
    :attackspeed_per_level
  ]

  @type t :: %__MODULE__{
    hp: float(),
    hp_per_level: float(),
    mp: float(),
    mp_per_level: float(),
    movespeed: float(),
    armor: float(),
    armor_per_level: float(),
    spellblock: float(),
    spellblock_per_level: float(),
    attackrange: float(),
    hp_regen: float(),
    hp_regen_per_level: float(),
    mp_regen: float(),
    mp_regen_per_level: float(),
    crit: float(),
    crit_per_level: float(),
    attack_damage: float(),
    attack_damage_per_level: float(),
    attackspeed: float(),
    attackspeed_per_level: float()
  }

  @spec parse(map()) :: t()
  def parse(json) do
    %__MODULE__{
      hp: json["hp"],
      hp_per_level: json["hpperlevel"],
      mp: json["mp"],
      mp_per_level: json["mpperlevel"],
      movespeed: json["movespeed"],
      armor: json["armor"],
      armor_per_level: json["armorperlevel"],
      spellblock: json["spellblock"],
      spellblock_per_level: json["spellblockperlevel"],
      attackrange: json["attackrange"],
      hp_regen: json["hpregen"],
      hp_regen_per_level: json["hpregenperlevel"],
      mp_regen: json["mpregen"],
      mp_regen_per_level: json["mpregenperlevel"],
      crit: json["crit"],
      crit_per_level: json["critperlevel"],
      attack_damage: json["attackdamage"],
      attack_damage_per_level: json["attackdamageperlevel"],
      attackspeed: json["attackspeed"],
      attackspeed_per_level: json["attackspeedperlevel"]
    }
  end
end

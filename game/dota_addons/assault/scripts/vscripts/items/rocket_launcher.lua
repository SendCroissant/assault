
function Fire(keys)
  local particleName = "particles/units/heroes/hero_batrider/batrider_flamebreak.vpcf"
  local item = keys.ability
  local speed = item:GetSpecialValueFor('speed')
  local radius = item:GetSpecialValueFor('radius')
  local caster = keys.caster
  local target = keys.target_points[1]
  local origin = caster:GetOrigin()
  local vel = target - origin
  local len = vel:Length2D()
  local scale = speed/len
  vel = vel * Vector(scale, scale, scale)

  local projectile = ProjectileManager:CreateLinearProjectile({
    Ability           = item,
    EffectName        = particleName,
    vSpawnOrigin      = origin,
    fDistance         = len,
    fStartRadius      = 30,
    fEndRadius        = 30,
    Source            = caster,
    bHasFrontalCone   = true,
    iUnitTargetTeam   = DOTA_UNIT_TARGET_TEAM_BOTH,
    iUnitTargetFlags  = DOTA_UNIT_TARGET_FLAG_NONE,
    iUnitTargetType   = DOTA_UNIT_TARGET_ALL,
    bDeleteOnHit      = false,
    vVelocity         = vel,
    bProvidesVision   = false,
  });
  caster.projectile = projectile;
end

function Explosion(keys)
  local caster = keys.caster
  local item = keys.ability
  local radius = item:GetSpecialValueFor('radius')
  local min_dmg = item:GetSpecialValueFor('min_dmg')
  local max_dmg = item:GetSpecialValueFor('max_dmg')
  local point = keys.target_points[1]
  local target_teams = DOTA_UNIT_TARGET_TEAM_BOTH
  local target_types = DOTA_UNIT_TARGET_ALL
  local target_flags = DOTA_UNIT_TARGET_FLAG_NONE 
  local units = FindUnitsInRadius(caster:GetTeamNumber(), point, nil, radius, target_teams, target_types, target_flags, FIND_CLOSEST, false)

  for _,unit in ipairs(units) do
    local dist = (unit:GetOrigin() - point):Length2D()
    local dmg = min_dmg + (1 - dist/radius)*(max_dmg-min_dmg)
    ApplyDamage({ victim = unit, attacker = caster, damage = dmg, damage_type = DAMAGE_TYPE_PHYSICAL })
    local knockbackModifierTable =
    {
      should_stun = 0,
      knockback_duration = 0.2,
      duration = 0.2,
      knockback_distance = radius-dist,
      knockback_height = 50,
      center_x = point.x,
      center_y = point.y,
      center_z = point.z
    }
    unit:AddNewModifier(caster, nil, "modifier_knockback", knockbackModifierTable )
  end
end
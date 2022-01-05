class ActiveSupport::TimeWithZone::Jail < Safemode::Jail
  allow *Safemode.core_jail_methods(Time).uniq
end


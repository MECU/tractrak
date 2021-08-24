class RaceType < ApplicationRecord

    /*
     * The race type (800m, Gender, Relay, etc)
     */
    public function type()
    {
      return $this->hasMany('App\Models\Race', 'id', 'race_type')
  }

  public function isAthleteRace()
  {
    if ($this->athlete_team === 0) return true
    return false
    }

    public function isTeamRace()
    {
      if ($this->athlete_team === 1) return true
      return false
      }
      }

      end

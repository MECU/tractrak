class Country < ApplicationRecord
  /**
     * The teams in this state
     * @return \Illuminate\Database\Eloquent\Relations\HasManyThrough
     */
  public function teams()
  {
    return $this->hasManyThrough(\App\Models\Team::class, \App\Models\State::class, 'countryid', 'stateid', 'id')
  }

  /**
     * The teams in this state
     * @return \Illuminate\Database\Eloquent\Relations\HasMany
     */
  public function states()
  {
    return $this->hasMany(\App\Models\State::class, 'countryid', 'id')
  }
  }

  end

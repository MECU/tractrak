class Team < ApplicationRecord
  include Discard::Model

  /**
     * The database table used by the model.
     *
     * @var string
     */
  protected $table = 'teams'

  /**
     * The attributes that are not mass assignable.
     *
     * @var array
     */
  protected $guarded = ['id']

  /**
     * For soft deletes
     *
     * @var array
     */
  protected $dates = ['deleted_at']

  /*
     * The Athletes that belong on this Team
     */
  public function athletes()
  {
    return $this->belongsToMany('App\Models\Athlete')->withPivot('current')
  }

  /*
     * The race(s) this Team has
     */
  public function races()
  {
    return $this->morphToMany('App\Models\Race', 'competitor')
  }

  /**
     * Helper function to get name of team
     *     Normally not needed, but matches declaration in Athlete
     * @return string
     */
  public function getName()
  {
    return $this->name
  }

  public function state()
  {
    return $this->hasOne('App\Models\State', 'id', 'stateid')
  }
  }

  end

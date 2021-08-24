class State < ApplicationRecord
  include Discard::Model

  /**
     * The database table used by the model.
     *
     * @var string
     */
  protected $table = 'states'

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

  /**
     * The teams in this state
     * @return \Illuminate\Database\Eloquent\Relations\HasMany
     */
  public function teams()
  {
    return $this->hasMany('App\Models\Team', 'stateid', 'id')
  }
  }

  end

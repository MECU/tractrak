class Athlete < ApplicationRecord
  <?php namespace App\Models

  use Illuminate\Database\Eloquent\SoftDeletes

  /**
 * Class Athlete
 *  Gender: 0=male, 1=female
 */
  class Athlete extends \Eloquent {

    use SoftDeletes

    /**
	 * The database table used by the model.
	 *
	 * @var string
	 */
    protected $table = 'athletes'

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
	 * The team(s) this Athlete belongs to
	 */
    public function teams()
    {
      return $this->belongsToMany('App\Models\Team')->withPivot('current')
  }

  /*
	 * The race(s) this Athlete has
	 */
  public function races()
  {
    return $this->morphToMany('App\Models\Race', 'competitor')->withPivot('id', 'lane', 'result', 'place')
  }

  /**
     * Helper function to combine first and last name nicely
     * @return string
     */
  public function getName()
  {
    return $this->firstname . ' ' . $this->lastname
  }

  public function hasPicture(): bool
  {
    // TODO
  return false
  }

  public function urlName(): string
  {
    return str_replace([' '], '', htmlspecialchars($this->firstname . $this->lastname))
  }
  }

  end

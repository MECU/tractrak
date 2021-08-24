class Season < ApplicationRecord

    /*
	 * The meets owner of this meet
	 */
    public function meets()
    {
      $this->hasMany('App\Meet', 'season_id', 'id')
  }
  }

  end

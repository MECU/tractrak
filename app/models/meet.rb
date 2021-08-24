class Meet < ApplicationRecord
  include Discard::Model

  /**
     * The database table used by the model.
     *
     * @var string
     */
  protected $table = 'meets'

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
  protected $dates = ['deleted_at', 'meet_date']

  /**
     * The attributes that should be casted to native types.
     *
     * @var array
     */
  protected $casts = [
    'points' => 'array',
  ]

  /*
     * The user owner of this meet
     */
  public function owner(): \Illuminate\Database\Eloquent\Relations\HasOne
  {
    return $this->hasOne(User::class, 'id', 'owner_id')
  }

  /*
     * The stadium the meet occurs at
     */
  public function stadium(): \Illuminate\Database\Eloquent\Relations\HasOne
  {
    return $this->hasOne(Stadium::class, 'id', 'stadium_id')
  }

  /**
     * @param integer $stadiumId
     * @return $this
     */
  public function setStadium($stadiumId): self
  {
    $stadium = Stadium::find($stadiumId)
  if ($stadium !== null) {
    $this->stadium_id = $stadiumId
  }

  return $this
  }

  /**
     * @param User $user
     * @return $this
     */
  public function setOwner(User $user): self
  {
    $this->owner_id = $user->id

  return $this
  }

  public function isPaid(): bool
  {
    return $this->paid === 1
  }

  /**
     * Is the meet ready? Is there a schedule? Did they pay?
     * @return bool
     */
  public function ready(): bool
  {
    // TODO Uncomment once paying turned on
  // return ($this->paid === 1 && $this->sch === 1)
  return $this->sch === 1
  }

  public function qr(): QrCode
  {
    $qrCode = new QrCode()
  $qrCode->setWriterByName('png')
  $qrCode->setText(URL::route('frontend.meet.live', ['id' => $this->id]))
  $qrCode->setSize(300)
  $qrCode->setMargin(10)
  $qrCode->setErrorCorrectionLevel(new ErrorCorrectionLevel(ErrorCorrectionLevel::HIGH))
  $qrCode->setForegroundColor(['r' => 0, 'g' => 0, 'b' => 0, 'a' => 0])
  $qrCode->setBackgroundColor(['r' => 255, 'g' => 255, 'b' => 255, 'a' => 0])
  $qrCode->setLabel('TracTrak.com', 24)

  return $qrCode
  }

  public function generatePDF(): \Illuminate\Http\Response
  {
    $pdf = PDF::loadView('flyer', [
      'meet' => $this,
      'qr' => $this->qr(),
    ])

  return $pdf->download('TracTrak-meet-flyer.pdf')
  }

  public function races(): \Illuminate\Database\Eloquent\Relations\HasMany
  {
    return $this->hasMany(Race::class)
  }
  }

  end

class Meet < ApplicationRecord
  include Discard::Model

  has_one :owner, class_name: 'User', foreign_key: 'owner_id'
  has_one :stadium
  has_many :races

  def set_stadium(id)
    stadium = Stadium.find!(id)
    stadium_id = id
  end

  def set_owner(id)
    owner_id = id
  end

  def paid?
    return true
    paid === 1 # enable when paying is required
  end

  def ready?
    sch && evt && ppl && paid?
  end

  def qr
    # TODO
    #
    # $qrCode = new QrCode()
    # $qrCode->setWriterByName('png')
    # $qrCode->setText(URL::route('frontend.meet.live', ['id' => $this->id]))
    # $qrCode->setSize(300)
    # $qrCode->setMargin(10)
    # $qrCode->setErrorCorrectionLevel(new ErrorCorrectionLevel(ErrorCorrectionLevel::HIGH))
    # $qrCode->setForegroundColor(['r' => 0, 'g' => 0, 'b' => 0, 'a' => 0])
    # $qrCode->setBackgroundColor(['r' => 255, 'g' => 255, 'b' => 255, 'a' => 0])
    # $qrCode->setLabel('TracTrak.com', 24)
    #
    # return $qrCode
  end

  def generate_pdf
    # TODO
    #
    # $pdf = PDF::loadView('flyer', [
    #   'meet' => $this,
    #   'qr' => $this->qr(),
    # ])
    #
    # return $pdf->download('TracTrak-meet-flyer.pdf')
  end

  def serialized
    [
      'link' => URL::route('frontend.meet.live', ['id' => id]),
      'name' => name,
      'datetime' => meet_date.format('Y-m-d g:ia')
    ]
  end
end

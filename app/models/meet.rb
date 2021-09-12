class Meet < ApplicationRecord
  include Discard::Model

  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'
  belongs_to :season, optional: true
  belongs_to :stadium, optional: true
  has_many :races

  def paid?
    true
    # paid === 1 # enable when paying is required
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
end

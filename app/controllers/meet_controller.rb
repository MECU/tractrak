class MeetController < ApplicationController
  def meet

  end

  def event

  end

  def live
    @meet = Meet.find(params[:id])
  end

  def data
    @meet = Meet.find(params[:id])
  end

  def team_standings

  end

  def pdf
    @meet = Meet.find(params[:id])

    html = render_to_string(template: 'meet/flyer', locals: { meet: @meet }, layout: false)
    pdf = WickedPdf.new.pdf_from_string(html)

    send_data(
      pdf,
      :filename => "tractrak-meet-#{@meet.id}.pdf",
      :disposition => 'attachment',
      :show_as_html => true
    )
  end
end

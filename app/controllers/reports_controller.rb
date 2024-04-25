class ReportsController < ApplicationController  
    def total
        # Controller or Service
      @daily_records = DailyRecord.order('id').page(params[:page]).per(100) # Paginate with 10 records per page      
      liquid_template = Liquid::Template.parse(File.read('app/views/reports/index.liquid'))
      rendered_template = liquid_template.render('daily_records' => @daily_records.map(&:attributes), )
      render html: rendered_template.html_safe
  end
end

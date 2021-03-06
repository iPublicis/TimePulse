require 'spec_helper'

describe PaidBillQuery, :type => :query do

  before :each do
    @bill = FactoryGirl.create(:bill, :due_on => Date.today + 1.week)
    @unpaid_bills = [
        @bill,
        FactoryGirl.create(:bill, :paid_on => nil, :due_on => Date.today + 1.month),
        FactoryGirl.create(:bill, :paid_on => nil, :due_on => Date.today + 3.weeks)
    ].sort_by{|b| b.due_on}.reverse
    @paid_bills = [
      FactoryGirl.create(:bill, :paid_on => Date.today - 1.day),
      FactoryGirl.create(:bill, :paid_on => Date.today - 2.day)
    ].sort_by{|b| b.paid_on}.reverse
  end

  subject do
    PaidBillQuery.new
  end

  it "should find the paid bills" do
    subject.find_for_page(nil).should == @paid_bills.paginate
  end
end
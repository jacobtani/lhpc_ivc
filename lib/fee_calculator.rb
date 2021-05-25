# for each child -< grouped by FAMILY ID, 
# check if they have a caregiver -> then you can pull out the caregiver fee structure and be done
# if not, then check the size of the enrolled days account and if this is greater than 1 use the fee structure for multiple days
# if not use the fee structure where multiple enrolled days is false
# with the latter two, need to check if their parent has any qualification and if so need to apply that discount to the member donation
# should return back the member donation, cleaning donation, discount (this should have the qualification discount and allow for further discounts) and total to pay
# these figures then put into the prawn template as well as the member details then it can generate
## allowance for further manual invoicing - adding extra line items

class FeeCalculator
  attr_reader :member_donation, :cleaning_donation

  def initialize(member:)
    @member = member
  end

  def call
    if @member.has_caregiver
      fetch_caregiver_fees
    else
      calculate_non_caregiver_fees
    end
  end

  private

  def fetch_caregiver_fees
    caregiver_fees = FeeStructure.active.where(caregiver_fees: true).first
    @member_donation = caregiver_fees.base_member_donation
    @cleaning_donation = caregiver_fees.cleaning_donation
  end

  def calculate_non_caregiver_fees
    fees = calculate_base_fees
    @member_donation = fees.member_donation
    @cleaning_donation = fees.cleaning_donation
    apply_discounts
  end

  def calculate_base_fees
    if @member.enrolled_days.length > 1
      base_fees = fetch_multiple_enrolment_days_fees
    else
      base_fees = fetch_single_enrolment_days_fees
    end
    base_fees
  end

  def apply_discounts
    # Qualification discounts
    if @member.qualifications.any?
      discount_amount = @member.qualifications.first.discount_amount
      @member_donation = @member_donation - discount_amount
    end
  end

  def fetch_multiple_enrolment_days_fees
    multiple_enrolment_days_fees = FeeStructure.active.where(multiple_enrolment_days_fees: true).first
    { member_donation: multiple_enrolment_days_fees.base_member_donation, cleaning_donation = multiple_enrolment_days_fees.cleaning_donation }
  end

  def fetch_single_enrolment_days_fees
    single_enrolment_days_fees = FeeStructure.active.where(multiple_enrolment_days_fees: false).first
    { member_donation: single_enrolment_days_fees.base_member_donation, cleaning_donation = single_enrolment_days_fees.cleaning_donation }
  end
end

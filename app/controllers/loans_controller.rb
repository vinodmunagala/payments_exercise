class LoansController < ActionController::API

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: 'not_found', status: :not_found
  end

  def index
    allPaymentsSum =  Payment.group(:loan_id).sum(:amount)
    allLoans = Loan.all
    if (allLoans.size >0)
    loanArray = []
    for loan in allLoans
    outstanding_amount = loan[:funded_amount] - allPaymentsSum[loan[:id]]
    loanArray.push({
      loan_id: loan[:id],
      funded_amount: loan[:funded_amount],
      created_at: loan[:created_at],
      updated_at: loan[:updated_at],
      outstanding_amount: outstanding_amount,
    })
    end
    render json: loanArray
    else
      render json: "No Data present"
    end
  end

  def show
    allPaymentSum = Payment.where(:loan_id => params[:id]).sum(:amount)
    loan = Loan.find(params[:id])
    if (loan != nil)
      outstanding_amount = loan[:funded_amount] - allPaymentSum
      render json: {
        loan_id: loan[:id],
        funded_amount: loan[:funded_amount],
        created_at: loan[:created_at],
        updated_at: loan[:updated_at],
        outstanding_amount: outstanding_amount,
      }
    else
      render json: "Loan Not Found"
    end
  end

  def payments
    loan_id = params[:loan][:loan_id]
    payment_amount = params[:loan][:amount]
    funded_amount = Loan.find(loan_id)[:funded_amount]
    total_payed_amount = Payment.where(:loan_id => loan_id).sum(:amount); 
    print(total_payed_amount)
    print(funded_amount)
    if (funded_amount > total_payed_amount + payment_amount)
    Payment.create(:amount => payment_amount , :loan_id => loan_id )
    render json: "Request completed"
    else
      render json: "Total payment amount is greater than loan amount"
    end
  end

  def allPayments
    allPayments = Payment.all
    if (allPayments.size > 0)
      render json: allPayments
    else
      render json: "No Payments in Database"
    end
  end

  def showPaymentsForALoan
    allPayments = Payment.where(:loan_id => params[:id])
    if (allPayments.size > 0)
    render json: allPayments
    else
      render json: "No Payments for given loan id"
    end
  end
end

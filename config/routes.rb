Rails.application.routes.draw do
  post 'loans/payments', to: 'loans#payments' ,as: 'payments'
  get 'loans/allPayments', to:'loans#allPayments', as: 'allPayments' ,defaults: {format: :json}
  get 'loans/showPaymentsForALoan/:id', to: 'loans#showPaymentsForALoan', as: 'showPaymentsForALoan' ,defaults: {format: :json}
  resources :loans, defaults: {format: :json}
end
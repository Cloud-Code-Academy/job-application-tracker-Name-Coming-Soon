import { LightningElement } from 'lwc';

const medicareRate = 0.0145;
const socialSecurityRate = 0.0620;
const federalStandardDeduction = 12950; // Federal standard deduction for single filer
const stateStandardDeduction = 4803; // State standard deduction for single filer
const totalStandardDeduction = federalStandardDeduction + stateStandardDeduction;
const federalTaxBrackets = [
  { min: 0, max: 11000, rate: 0.10 },
  { min: 11001, max: 43750, rate: 0.12 },
  { min: 43751, max: 115000, rate: 0.22 },
  { min: 115001, max: 182000, rate: 0.24 },
  { min: 182001, max: 231750, rate: 0.32 },
  { min: 231751, max: 578125, rate: 0.35 },
  { min: 578126, max: Infinity, rate: 0.37 }
];

export default class TakeHomePayCalculator extends LightningElement {
  income = 0;
  salaryDeductions = 0;
  federalWithholding = 0;
  medicareWithholding = 0;
  socialSecurityWithholding = 0;
  taxableIncome = 0;
  takeHomePay = 0;
  semiAnnualPay = 0;
  monthlyPay = 0;
  biWeeklyPay = 0;

  handleIncomeChange(event) {
    this.income = event.target.value;
    this.Calculate();
  }

  preventDefaultAndHandleCalculate(event) {
    console.log('preventDefaultAndHandleCalculate called');
    event.preventDefault(); // Prevent the default button behavior (page refresh)
    this.handleCalculate();
  }

  handleCalculate() {
    this.Calculate();
  }

  Calculate() {
    this.federalWithholding = this.calculateFederalTax().toFixed(2);
    this.taxableIncome = this.income > totalStandardDeduction ? this.income - totalStandardDeduction : this.income;
    this.medicareWithholding = (this.income * medicareRate).toFixed(2);
    this.socialSecurityWithholding = (this.income * socialSecurityRate).toFixed(2);
    this.salaryDeductions = parseFloat(this.federalWithholding) + parseFloat(this.medicareWithholding) + parseFloat(this.socialSecurityWithholding);
    this.takeHomePay = (this.income - this.salaryDeductions).toFixed(2);
    this.semiAnnualPay = (this.takeHomePay / 2).toFixed(2);
    this.monthlyPay = (this.takeHomePay / 12).toFixed(2);
    this.biWeeklyPay = (this.takeHomePay / 26).toFixed(2);

    this.updateInputFields();
  }

  updateInputFields() {
    this.template.querySelector('#text-input-salarydeductions').value = this.salaryDeductions;
    this.template.querySelector('#text-input-federaltax').value = this.federalWithholding;
    this.template.querySelector('#text-input-medicare').value = this.medicareWithholding;
    this.template.querySelector('#text-input-socialsecurity').value = this.socialSecurityWithholding;
    this.template.querySelector('#text-input-taxableincome').value = this.taxableIncome;
    this.template.querySelector('#text-input-takehomepay').value = this.takeHomePay;
    this.template.querySelector('#text-input-semestralpay').value = this.semiAnnualPay;
    this.template.querySelector('#text-input-monthlypay').value = this.monthlyPay;
    this.template.querySelector('#text-input-biweeklypay').value = this.biWeeklyPay;
  }

  calculateFederalTax() {
    let federalTax = 0;
    let incomeMinusStandardDeduction = this.income - totalStandardDeduction;
    for (const bracket of federalTaxBrackets) {
      if (incomeMinusStandardDeduction <= bracket.max || !bracket.max) {
        federalTax = (bracket.rate * (incomeMinusStandardDeduction - bracket.min)) + (bracket.min * bracket.rate);
        break;
      }
    }
    return federalTax > 0 ? federalTax : 0;
  }
}
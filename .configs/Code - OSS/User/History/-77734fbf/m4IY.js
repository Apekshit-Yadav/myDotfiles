const subbed = document.getElementById("mycheckbox");
const card1 = document.getElementById("card1");
const card2 = document.getElementById("card2");
const card3 = document.getElementById("card3");
const submitto = document.getElementById("subbtn");
const para = document.getElementById("mypara");
const paymentMethod = document.getElementById("paymentmethod");

submitto.onclick=function(){
    
    if(subbed.checked){
        para.textContent=`You are gonna get some !! now select payment method`;
    }
    else {
        para.textContent=`Proceed to payment and get some :)`
    }

    if(card1.checked){
        paymentMethod.textContent=`Paying with Mastercard`;
    }
    else if(card2.checked){
        paymentMethod.textContent=`Paying with Visa`;
    }
    else if(card3.checked){
        paymentMethod.textContent=`Paying with PayPal`;
    }
    else 
    {
        paymentMethod.textContent=`please choose a payment method`;
    }
}
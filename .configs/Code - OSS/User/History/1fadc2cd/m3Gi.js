let num1;
let num2;
let num3;
const min=1; 
const max=6;
const roll = document.getElementById("generator");
const haedin = document.getElementById("mynum1");
const haeding = document.getElementById("mynum2");
const haedingg = document.getElementById("mynum3");

roll.onclick=function(){
    num1=Math.floor(Math.random()*max)+min;
    num2=Math.floor(Math.random()*max)+min;
    num3=Math.floor(Math.random()*max)+min;
    haedin.textContent=num1;
    haeding.textContent=num2;
    haedingg.textContent=num3;
}
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
    num=Math.floor(Math.random()*max)+min;
    haedin.textContent=num;
    haeding.textContent=num;
    haedingg.textContent=num;

}
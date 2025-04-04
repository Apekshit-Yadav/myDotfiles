let testScore = 3;
let gradeCheck;

switch(true){
    case testScore>90:
        gradeCheck="A";
        break;
    case false:
        gradeCheck="failure";
        console.log("this is falsecase");
        break;
    default:
        console.log("pfft");
}

console.log(gradeCheck);
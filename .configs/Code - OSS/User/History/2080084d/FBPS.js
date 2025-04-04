let testScore = 93;
let gradeCheck;

switch(false){
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
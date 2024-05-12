const element1 = document.querySelector('#loginAdmin');
if(element1){
    element1.addEventListener('click', function(event) {
        event.preventDefault(); 
        window.location.href = 'admin-login.html'; 
    });
}

const element2 = document.querySelector('#signup');
if(element2){
    element2.addEventListener('click', function(event) {
        event.preventDefault(); 
        window.location.href = 'customer-signup.html'; 
    });
}
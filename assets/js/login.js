document
.getElementById("togglePassword")
.addEventListener("click", function () {

    let password =
        document.getElementById("password");

    if(password.type === "password"){

        password.type = "text";

        this.className = "bi bi-eye-slash";

    }else{

        password.type = "password";

        this.className = "bi bi-eye";

    }

});
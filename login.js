function handleGoogleLogin(response) {
	console.log(response);
	if (response.error) {
		// Handle error
		console.error("Sign-in failed:", response.error);
		return;
	}
	// Handle successful sign-in
	console.log("Sign-in successful");
	document.getElementById("google_client_id").value = response.client_id;
}

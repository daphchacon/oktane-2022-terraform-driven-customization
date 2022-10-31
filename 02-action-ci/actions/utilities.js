export const restrictedAppName = "RESTRICTED_APP_NAME";

export const isLoginValid = (event) => {
    return event.client.name !== restrictedAppName;
}

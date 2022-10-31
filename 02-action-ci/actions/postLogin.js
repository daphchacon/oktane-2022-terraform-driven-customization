import { isLoginValid } from "./utilities";

/**
 * Handler that will be called during the execution of a PostLogin flow.
 *
 * @param {Event} event - Details about the user and the context in which they are logging in.
 * @param {PostLoginAPI} api - Interface whose methods can be used to change the behavior of the login.
 */
export async function onExecutePostLogin(event, api) {
    if (!isLoginValid(event)) {
        api.access.deny("Login to this app is restricted.");
    }
}
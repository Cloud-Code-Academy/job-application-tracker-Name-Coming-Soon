import { LightningElement } from 'lwc';
import executeJoobleIntegration from '@salesforce/apex/ButtonForJooble.executeJoobleIntegration';

export default class JoobleIntegrationButton extends LightningElement {
    handleClick() {
        executeJoobleIntegration()
            .then(result => {
                // Handle success
                console.log('Jooble integration completed successfully');
            })
            .catch(error => {
                // Handle error
                console.error('Error occurred during Jooble integration:', error);
            });
    }
}
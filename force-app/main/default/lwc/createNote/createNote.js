import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { createRecord } from 'lightning/uiRecordApi';

export default class CreateNoteLWC extends LightningElement {
    @api parentId; 

    noteTitle = '';
    noteBody = '';

    handleTitleChange(event) {
        this.noteTitle = event.target.value;
    }

    handleBodyChange(event) {
        this.noteBody = event.target.value;
    }

    handleSaveClick() {
        const fields = {
            Title: this.noteTitle,
            Body: this.noteBody,
            ParentId: this.parentId
        };

        const recordInput = { apiName: 'Note', fields };

        createRecord(recordInput)
            .then(result => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Note created successfully',
                        variant: 'success'
                    })
                );

                this.dispatchEvent(new CustomEvent('notecreated'));

                this.noteTitle = '';
                this.noteBody = '';
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error creating note',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
            });
    }
}
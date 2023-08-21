import { LightningElement, api, wire } from 'lwc';
import getNotesRelatedToCases from '@salesforce/apex/NoteController.getNotesRelatedToCases';
import { getRecord, createRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';

const COLUMNS = [
    { label: 'Title', fieldName: 'Title', type: 'url', typeAttributes: { label: { fieldName: 'Title' }, target: '_blank' } },
    { label: 'Created By', fieldName: 'CreatedByName', type: 'text' }, 
    { label: 'Created Date', fieldName: 'FormattedCreatedDate', type: 'text' } 
];
const FIELDS = ['Case.AccountId', 'Case.OwnerId'];

export default class NoteComponent extends NavigationMixin(LightningElement) {
    @api recordId; 
    accountId;
    ownerId;
    notesRelatedToAccount = [];
    selectedNoteId;
    isModalOpen = false;

    columns = COLUMNS;

    @wire(getNotesRelatedToCases, { caseId: '$recordId' })
    wiredNotesData({ error, data }) {
        if (data) {
            this.notesRelatedToAccount = data.map(note => {
                return {
                    ...note,
                    CreatedByName: note.CreatedBy.FirstName +' '+ note.CreatedBy.LastName,
                    FormattedCreatedDate: new Date(note.CreatedDate).toLocaleDateString()
                };
            });
        } else if (error) {
            console.error(error);
        }



        
    }

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    wiredCase({ error, data }) {
        if (data) {
            this.accountId = data.fields.AccountId.value;
            this.ownerId = data.fields.OwnerId.value;
        } else if (error) {
            console.error(error);
        }
    }

    handleClickNew() {
        this.isModalOpen = true;
    }

    handleModalClose() {
        this.isModalOpen = false;
    }

    handleNoteCreated(event) {
        if (event.detail) {
            this.notesRelatedToAccount.unshift(event.detail);
        }
        this.isModalOpen = false;
    }

    handleRowAction(event) {
        const action = event.detail.action;
        const row = event.detail.row;
        this.selectedNoteId = row.Id;

        if (action.name === 'view') {
            const accountUrl = `https://yourinstance.lightning.force.com/lightning/r/Account/${this.accountId}/view`;
            window.open(accountUrl, '_blank');
        }
    }
}
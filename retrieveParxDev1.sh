#!/bin/bash
ant -propertyfile build.properties retrieveUnpackaged

echo 'replacing the ids'

# Record Types:
# MedicalRecord ActivationReport RecordType Id
sed -i '' -e 's/012M00000008UU2/012M0000000Ch4d/g' retrieveUnpackaged/tabs/*
sed -i '' -e 's/012M00000008UU2/012M0000000Ch4d/g' retrieveUnpackaged/objects/*
# Medical Record SurgeryReport RecordType Id
sed -i '' -e 's/012M00000008UU7/012M0000000Ch4e/g' retrieveUnpackaged/tabs/*
sed -i '' -e 's/012M00000008UU7/012M0000000Ch4e/g' retrieveUnpackaged/objects/*

# Field preselect urls:
# Patient --> RelationCustomerPatient__c Assign Clinic/Distributor Patient Textfield
sed -i '' -e 's/CF00ND0000003MsOU/CF00NM0000000Sgry/g' retrieveUnpackaged/objects/*
# Customer --> RelationCustomerPatient__c Assign Patient Customer Textfield
sed -i '' -e 's/CF00ND0000003MsOe/CF00NM0000000Sgrs/g' retrieveUnpackaged/objects/*

# Professional --> RelationCustomerProfessionals__c Assign Customer Professional Textfield
sed -i '' -e 's/CF00ND0000003MsNq/CF00NM0000000SgsF/g' retrieveUnpackaged/objects/*
# Customer --> RelationCustomerProfessionals__c Assign Professional Customer Textfield
sed -i '' -e 's/CF00ND0000003MsNl/CF00NM0000000Sgs2/g' retrieveUnpackaged/objects/*

# Patient --> RelationProfessionalPatient__c Assign Professional Patient Textfield
sed -i '' -e 's/CF00ND0000003MsOP/CF00NM0000000SgsU/g' retrieveUnpackaged/objects/*
# Professional --> RelationProfessionalPatient__c Assign Patient Professional Textfield
sed -i '' -e 's/CF00ND0000003MsOK/CF00NM0000000Sgsg/g' retrieveUnpackaged/objects/*
# Patient --> RelationPatientContact__c Assign Contact Patient Textfield
sed -i '' -e 's/CF00ND0000003MtjK/CF00NM0000000SgsL/g' retrieveUnpackaged/objects/*

# Set the sharing model to public (private not supported yet by meta data api)
# sed -i '' -e 's/\<sharingModel>Private\<\/sharingModel>/\<sharingModel>ReadWrite\<\/sharingModel>/g' retrieveUnpackaged/objects/*


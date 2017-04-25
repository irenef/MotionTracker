function f = uvsFieldNames()
% uvsFieldNames - returns a struct that is basically an enum, containing the
% field names for the uvs motion model.
f = fmtMake( { 'U','V','S', 'X0', 'Y0' } );
end
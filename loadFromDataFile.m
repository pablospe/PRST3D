function data = loadFromDataFile(filename)
fileID = fopen(filename);

version = fread(fileID, 1, 'uchar')
endian = fread(fileID, 1, 'uchar')
uintSize = fread(fileID, 1, 'uchar')
elemSize = fread(fileID, 1, 'uint32')
xDim = fread(fileID, 1, 'uint32')
yDim = fread(fileID, 1, 'uint32')
zDim = fread(fileID, 1, 'uint32')

data = fread(fileID, xDim*yDim*zDim, 'float');
data = reshape(data, [xDim, yDim, zDim]);

fclose(fileID);
end

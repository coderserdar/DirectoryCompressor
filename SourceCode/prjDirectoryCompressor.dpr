program prjDirectoryCompressor;

{$APPTYPE CONSOLE}



// AbZipper denen nesne sýkýþtýrma bileþeni olan
// Abbrevia bileþeninin bir uniti oluyor
// bu nesne sayesinde bir klasör içerisinde
// recursive bir þekilde arama yaparak
// bütün alt klasör ve dosyalarý stek bir zip dosyasý olarak
// sýkýþtýrabileceðiz.
uses
  WinTypes,
  SysUtils, AbZipper;


// recursive olarak belirtilen klasörü geziyor
// 2. parametre ise
// Abbrevia adlý sýkýþtýrma bileþeninin bir nesnesi
// esas iþi o yapýyor zaten
procedure CompressFiles(directoryPath: string; compressor: TAbZipper);
var
//  compressor: TAbZipper;
  compressFileRec: TSearchRec;
  result: Integer;
begin
  try
    result := FindFirst(directoryPath + '\*.*', faDirectory, compressFileRec);
    while result = 0 do
    begin
      if (compressFileRec.Name <> '.') and (compressFileRec.Name <> '..') then
      begin
        CompressFiles(directoryPath + '\' + compressFileRec.Name, compressor);
      end;
      result := FindNext(compressFileRec);
    end;
    FindClose(compressFileRec);

    result := FindFirst(directoryPath + '\*.*', faAnyFile, compressFileRec);
    while result = 0 do
    begin
      compressor.AddFiles(directoryPath + '\' + compressFileRec.Name, faAnyFile);
      result := FindNext(compressFileRec);
    end;
    FindClose(compressFileRec);
  finally
  end;
end;



// program bir console application
// burada önemli olan nokta ise
// eðer bu exe dosyasý çalýþtýrýlýrken parametre almýþsa
// aldýðý parametre dosyalarýn sýkýþtýrýlacaðý dizin oluyor ve
// ilgili metoda yönlendiriyor
// parametre almazsa bulunduðu klasördeki dosyalarý sýkýþtýrmaya
// yani ziplemeye baþlýyor
// Abbrevia bileþenini burada bir kere oluþturuyoruz
// ve metoda gönderip iþimiz bitince ortadan kaldýrýyoruz
var
  directoryPath: string;
  zipper: TAbZipper;
begin
  if ParamCount = 1 then
  begin
    directoryPath := ParamStr(1);
    if DirectoryExists(directoryPath) then
    begin
      zipper := TAbZipper.Create(nil);
//      zipper.BaseDirectory := ExpandFileName(directoryPath + '\..');
      zipper.BaseDirectory := ExtractFilePath(directoryPath);
      zipper.FileName := ChangeFileExt(directoryPath, '.zip');
      CompressFiles(directoryPath, zipper);
      zipper.Save;
      zipper.CloseArchive;
      zipper.Free;
    end;
  end
  else
  begin
    directoryPath := GetCurrentDir;
    zipper := TAbZipper.Create(nil);
    zipper.BaseDirectory := ExtractFilePath(directoryPath);
    zipper.FileName := ChangeFileExt(directoryPath, '.zip');
    CompressFiles(directoryPath, zipper);
    zipper.Save;
    zipper.CloseArchive;
    zipper.Free;
  end;
end.


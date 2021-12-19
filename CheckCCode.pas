//
// CheckCCode.pas
//
//   2021/12/19 TEncoding.GetEncoding�Ŏ擾�����I�u�W�F�N�g���J�����Ă��Ȃ�����
//              �s����C���i�s��񍐂Ɋ��Ӂj
//
//   Copyright(c) 2018/1/20 INOUE, masahiro
//
//   function CheckCharCode:
//	   Original -> function InCodeCheck: Copylight EarthWave Soft(IKEDA Takahiro)
//   	 Modified by M&I (INOUE, masahiro)
//
// ����͂ȂɁH
//   IKEDA Takahiro�����Jconvert.pas����R�[�h�`�F�b�N���������𔲂��o��
//   UTF-8/UTF-8N�`�F�b�N�Ɖ摜�t�@�C���`�F�b�N��ǉ��������̂ł�
//   Jconert.pas�ł́A���̑��ɕ����R�[�h�ϊ������ȂǑ����̋@�\����������
//   ���܂������A�ŐV��Delphi�ł͕W���֐��ŕ����R�[�h�ϊ����\�ł��邽��
//   �����R�[�h��ޔ��肾���ɂ��ڂ��Ă��܂�
//   �܂��A�e�L�X�g�t�@�C���̓ǂݏ�����Delphi�W���@�\�Ŏ������܂���
//
// �Ĕz�z�A���ρA���p�Ƃ��Ɏ��R�ɍs���ĉ������B�܂��A���̍ۂɘA�������s�v�ł�
//
unit CheckCCode;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes;

const
	// �R�[�h�y�[�W
	CP_ANSI	 		= 1252;
  CP_SJIS    	= 932;
  CP_EUCJP   	= 20932;
  CP_JIS     	= 50220;
  CP_UTF7			= 65000;
  CP_UTF8    	= 65001;
  CP_UTF8N		= CP_UTF8 + 1;	// UTF-8N�͒�`����Ă��Ȃ��̂�UTF-8+1�Œ�`����
  CP_UTF16LE 	= 1200;
  CP_UTF16BE 	= 1201;

  UNKNOWN			= -1;
	BINARY      = 0;
  EUCorSJIS		= 2;

  BR_CRLF			= 10;
  BR_CR				= 11;
  BR_LF				= 12;

  PICT_BMP		= 20;
  PICT_JPG		= 21;
  PICT_GIF    = 22;
  PICT_PNG		= 23;

  DEF_CHK_LEN	= 512;

  ESC 				= $1B;
  SS2 				= $8E;

var
	CODE_CHK_LEN: integer = DEF_CHK_LEN;
  DETECTED_CODE,
  DETECTED_BREAK: integer;
  BREAK_CHAR: string = #13#10;


// �����R�[�h�𔻕ʂ���
//
// SecText: ���肷�镶����(���̃R�[�h��������String�ɃL���X�g����ĕω�
//												 ���Ȃ��悤Byte�f�[�^�Ƃ��ēn��)
// Size:    �`�F�b�N���镶�������w�肷��(�f�t�H���g��512Byte)
//          Size���ȗ������ꍇ��CODE_CHK_LEN�̃T�C�Y�Ń`�F�b�N����
// Result:  �����R�[�h�̎��
function CheckCharCode(SrcText: PByte; Size: integer): integer; overload;
function CheckCharCode(SrcText: PByte): integer; overload;

// BMP, JPG, GIF, PNG�摜���ǂ������`�F�b�N����
//
// SrcData: ���肷��f�[�^��
// Result:  �摜�t�@�C���̎��
function CheckPictKind(SrcData: PByte): integer;

// �����R�[�h�����ϊ����[�h
//
// FileName:�ǂݍ��ރt�@�C����
// Result:  �����ϊ����ꂽ�e�L�X�g������
function AutoCovertLoadFromFile(FileName: string): string;

// �����R�[�h�ϊ����[�h
//
// FileName:�ǂݍ��ރt�@�C����
// CodeType:�ϊ����镶���R�[�h�̎��
// Result:  �����ϊ����ꂽ�e�L�X�g������
function CovertLoadFromFile(FileName: string; CodeType: integer): string;

// �����R�[�h�ϊ��Z�[�u
//
// FileName:�ۑ�����t�@�C����
// CodeType:�ϊ����镶���R�[�h�̎��
// BreakChar:�ۑ�������s�R�[�h�̎��(�ȗ������ꍇ��BREAK_CHAR�ƂȂ�)
procedure ConvertSaveToFile(FileName: string; SrcText: string; CodeType: integer); overload;
procedure ConvertSaveToFile(FileName: string; SrcText: string; CodeType: integer; BreakChar: string); overload;


implementation


function CheckCharCode(SrcText: PByte; Size: integer): integer;
var
	index, c, jmode, sz: integer;
	utfk: Boolean;
  s: PByte;
begin
	// Size = 0 �̏ꍇ
	if Size = 0 then
	begin
		Result := BINARY;
		Exit;
	end;

	index := 0;
  sz    := Size - 2;
  s			:= SrcText;
	jmode := CP_ANSI;
	DETECTED_CODE := CP_ANSI;
  // Unicode LE/BE��UTF-8��BOM���`�F�b�N����
	if (Size > 2 ) then
	begin
		// UNICODE(Little Endian)�`�F�b�N
    if (s[0] = $FF) and (s[1] = $FE) then
		begin
  		DETECTED_CODE := CP_UTF16LE;
			Result 				:= CP_UTF16LE;
			Exit;
		end;
		// UNICODE(Big Endian)�`�F�b�N
		if (s[0] = $FE) and (s[1] = $FF) then
		begin
  		DETECTED_CODE := CP_UTF16BE;
			Result 				:= CP_UTF16BE;
			Exit;
		end;
	end;
	if Size > 3 then
		// UTF-8(BOM����)�`�F�b�N
		if (s[0] = $EF) and (s[1] = $BB) and (s[2] = $BF) then
		begin
  		DETECTED_CODE := CP_UTF8;
			Result 				:= CP_UTF8;
			Exit;
		end;

  // Shift-JIS, EUC, JIS, UTF-8N���`�F�b�N����
	while ((jmode = CP_ANSI) or (jmode = EUCorSJIS)) and (index <= Size) do
  begin
    //�Ō�̕����͒��ׂȂ��i���[�v���Œ��ׂ�Ƃ�������j
    if index >= sz then
      Break;
    c := s[index];
    if c = ESC  then
    begin
      Inc(index);
      c := Ord(s[index]);
      if c = Ord('$') then
      begin
        Inc(index);
				c := Ord(s[index]);
        if c = Ord('B') then
          jmode := CP_JIS           {JIS X0208-1983}
        else if c = Ord('@') then
          jmode := CP_JIS;          {JIS X0208-1978 Old JIS}
      end;
		end else if (c in [0..7]) or (c = $FF) then
		begin
			jmode := BINARY;
		end else if c > $7f then
		begin
      if (c in [$81..$8D]) or (c in [$8F..$9F]) then
        jmode := CP_SJIS
      else if c = SS2 then      {SS2 �� EUC �� JIS X0201 ����(1Byte)}
      begin                     {�ւ̈ڍs������}
        Inc(index);
        c := s[index];
        if (c in [$40..$7E]) or (c in [$80..$A0]) or (c in [$E0..$FC]) then
          jmode := CP_SJIS
        else if (c in [$A1..$DF]) then   {EUC JIS X0201 ���� �̉\��}
          jmode := EUCorSJIS;
			end else if c in [$A1..$DF] then   {SJIS �ł͔��p���ȗ̈�}
      begin
        Inc(index);
        c := s[index];
        if c in [$F0..$FE] then
          jmode := CP_EUCJP
        else if c in [$A1..$DF] then
          jmode := EUCorSJIS
        else if c in [$E0..$EF] then
        begin
          jmode := EUCorSJIS;
          while (c >= $40) and (index <= size) and (jmode = EUCorSJIS) do
          begin
            if c >= $81 then
            begin
              if (c <= $8D) or ( c in [$8F..$9C]) then {EUC �� A1..FF �̂͂�}
                jmode := CP_SJIS
                  // ���̃`�F�b�N������ƑS�p�J�^�J�i�Ђ炪�Ȃ����̏ꍇ��EUC
                  // ��SJIS�Ƃ����肷�邽�߃`�F�b�N���O����
							else// if c in [$FD..$FE] then  {SJIS �ł͔����Ă���̈�}
                jmode := CP_EUCJP;
            end;
            Inc(index);
            c := s[index];
          end;
        end else if c <= $9F then
          jmode := CP_SJIS;
      end else if c in [$F0..$FE] then
        jmode := CP_EUCJP
      else if c in [$E0..$EF] then
      begin
        Inc(index);
        c := s[index];
				if (c in [$40..$7E]) or (c in [$80..$A0]) then
          jmode := CP_SJIS
        else if c in [$FD..$FE] then
          jmode := CP_EUCJP
        else if c in [$A1..$FC] then
          jmode := EUCorSJIS;
			end;
    end;
    Inc(index);
	end;
  // Added by INOUE, masahiro
  // UTF-8N���`�F�b�N����
  // �`�F�b�N���镶����͈͓̔��Ɋ����R�[�h���Ȃ���UTF-8�Ɣ���o���Ȃ�����
  // �ꍇ�ɂ���Ă�Shift-JIS�ƊԈႦ��\��������
	if (jmode = EUCorSJIS) or(jmode = CP_EUCJP) or (jmode = CP_SJIS) then
 	begin
		index := 0;
		utfk := False;
		while index < (Size - 4) do
		begin
			c := s[index];
			if (c in [$C0..$DF]) or (c > $EF) then
			begin
				utfk := False;
				Break;
			end;
			if c in [0..$7F] then
			begin
				;
			end else if c = $E0 then
			begin
				Inc(index);
				c := s[index];
				if c in [$A0..$BF] then
				begin
					Inc(index);
					c := s[index];
					if c in [$80..$BF] then
          begin
						utfk := True;
             Break;
					end else begin
						utfk := False;
						Break;
					end;
				end else begin
					utfk := False;
					Break;
				end;
			end else if c in [$E1..$EF] then
			begin
				Inc(index);
				c := s[index];
				if c in [$80..$BF] then
				begin
					Inc(index);
					c := s[index];
					if c in [$80..$BF] then
          begin
						utfk := True;
            Break;
          end	else begin
						utfk := False;
						Break;
					end;
				end else begin
					utfk := False;
					Break;
				end;
			end else begin
				utfk := False;
				Break;
			end;
			Inc(index);
		end;
		// ��������������UTF-8N
		if utfk then
			jmode := CP_UTF8N;
	end;
  DETECTED_CODE := jmode;
	Result := jmode;
end;

function CheckCharCode(SrcText: PByte): integer;
begin
  Result := CheckCharCode(SrcText, CODE_CHK_LEN);
end;

function CheckPictKind(SrcData: PByte): integer;
var
	s: PByte;
begin
	s := SrcData;
  if (s[0] = Ord('B')) and (s[1] = Ord('M')) then
  	Result := PICT_BMP
  else if (s[0] = $FF) and (s[1] = $D8) and (s[2] = $FF) then
  	Result := PICT_JPG
  else if (s[0] = $89) and (s[1] = Ord('P')) and (s[2] = Ord('N')) then
  	Result := PICT_PNG
  else if (s[0] = Ord('G')) and (s[1] = Ord('I')) and (s[2] = Ord('F')) then
  	Result := PICT_GIF
  else
  	Result := UNKNOWN;
end;

function AutoCovertLoadFromFile(FileName: string): string;
var
	enc: TEncoding;
  mst: TMemoryStream;
  txt: TStringList;
  cdt, csz: integer;
  buf: PByte;
begin
	Result := '';
  mst := TMemoryStream.Create;
  try
    mst.LoadFromFile(FIleName);
    mst.Position := 0;
    buf := mst.Memory;
    csz := mst.Size;
    if csz > CODE_CHK_LEN then
    	csz := CODE_CHK_LEN;
    cdt := CheckCharCode(buf, csz);
 		DETECTED_CODE := cdt;
    if cdt <= 0 then	// �����R�[�h�����ʏo���Ȃ�
    	Exit;
  	txt := TStringList.Create;
  	try
    	if cdt = CP_UTF8N then
      begin
        cdt := CP_UTF8;
        txt.WriteBOM := False;
      end;
    	enc := TEncoding.GetEncoding(cdt);
      try
    	  txt.LoadFromStream(mst, enc);
			  if txt.LineBreak = #13#10 then
      	  DETECTED_BREAK := BR_CRLF
        else if txt.LineBreak = #13 then
				  DETECTED_BREAK := BR_CR
        else if txt.LineBreak = #10 then
      	  DETECTED_BREAK := BR_LF
        else
      	  DETECTED_BREAK := UNKNOWN;
    	  Result := txt.Text;
      finally
        enc.Free;
      end;
  	finally
  		txt.Free;
  	end;
  finally
    mst.Free;
  end;
end;

function CovertLoadFromFile(FileName: string; CodeType: integer): string;
var
	enc: TEncoding;
  txt: TStringList;
begin
	Result := '';
  txt := TStringList.Create;
  try
    enc := TEncoding.GetEncoding(CodeType);
    try
      txt.LoadFromFile(FileName, enc);
      Result := txt.Text;
    finally
      enc.Free;
    end;
  finally
  	txt.Free;
  end;
end;

procedure ConvertSaveToFile(FileName: string; SrcText: string; CodeType: integer);
begin
	ConvertSaveToFile(FileName, SrcText, CodeType, BREAK_CHAR);
end;

procedure ConvertSaveToFile(FileName: string; SrcText: string; CodeType: integer; BreakChar: string); overload;
var
	enc: TEncoding;
  txt: TStringList;
  cdt: integer;
begin
  txt := TStringList.Create;
  try
    txt.Text := SrcText;
  	cdt := CodeType;
    if cdt = CP_UTF8N then
    begin
    	cdt := CP_UTF8;
    	txt.WriteBOM := False;
    end;
    txt.LineBreak := BreakCHar;
    enc := TEncoding.GetEncoding(cdt);
    try
      txt.SaveToFile(FileName, enc);
    finally
      enc.Free;
    end;
  finally
  	txt.Free;
  end;
end;

end.

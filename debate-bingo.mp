
% bullshit bingo card
% prepared by patrick tj mcphee, december 2002 ptjm@interlog.com
% released to the public domain. have fun

% concept and many phrases taken from
%  http://www.perkigoth.com/home/kermit/stuff/BullshitBingo
% others from the list of banished words of Lake Superior State University:
%  http://www.lssu.edu/banished
% my thanks to all who have contributed to these efforts

% to run off a single card, give a command like
%  mpost bbcard
% and the card will written to bbcard.ps

% to run off cards for several players, try
%  mpost '\nocards := 7; input bbcard'
% and the cards will be written to bbcard.1, bbcard.2, .., bbcard.7

% to add additional phrases, duplicate one of the lines starting with
%  i := i + 1; bs[i] :=
% and replace the phrase in quotes
% I keep them in alphabetical order to ease maintenance, but you don't
% have to. I suggest commenting out phrases which are not known in
% your community and adding the irritating ones which are.

input breakwidth;

defaultfont := "ptmr8r";

prologues := 2;

radius := .5 cm;

offset := 1 cm;
boxwid := 1.9 cm;

bsmax := 0;

if not unknown file:
  string bs[];

  forever:
    string line;
    line := readfrom file;
    exitif line = EOF;
  
    if length line < 35:
      bsmax := bsmax + 1;
      bs[bsmax] := line;
    else:
      show "Line '" & line & "' had too many characters in it";
    fi; 
  endfor;
fi;

if bsmax < 24:
  show "Error: Must have at least 24 lines of input";
else:

% co-ordinates for the grid
pair bpos[], bpos[].ll, bpos[].ul, bpos[].ur, bpos[].lr;
   for i = 0 upto 4:
      for j = 0 upto 4:
        bpos[i+j*5+1] := ((j+0.5)*boxwid, (i+0.5)*boxwid);
        bpos[i+j*5+1].ll := (j*boxwid, i*boxwid);
        bpos[i+j*5+1].ul := (j*boxwid, (i+1)*boxwid);
        bpos[i+j*5+1].lr := ((j+1)*boxwid, i*boxwid);
        bpos[i+j*5+1].ur := ((j+1)*boxwid, (i+1)*boxwid);
      endfor;
   endfor;

picture bbcard[];

% the grid itself
bbcard[0] := image(
   z1 = (0, radius) = z2 - (0, 5boxwid - 2radius) =
        z6 - (5boxwid, 0) = z8 - (radius, -radius);
   z3 = z8 + (0, 5boxwid) = z4 - (5boxwid-2radius, 0);
   x5 = x6; y5 = y2;
   x7 = x4;
   y7 = y8;

   pickup pencircle xscaled 4pt yscaled 1pt rotated 30;

   draw z1---z2..z3---z4..z5---z6..z7---z8..cycle;

   fill ((unitsquare shifted -(.5,.5)) scaled boxwid) shifted bpos[13] withcolor .8 white;

   pickup pencircle scaled 1pt;
   for i = 2 upto 5:
	draw bpos[i].ll--bpos[i+20].lr;
   endfor;

   for i = 10 step 5 until 25:
	draw bpos[i].ul--bpos[i-4].ll;
   endfor;
);


% handle > 1 card if nocards was set on the command-line
if known nocards:
 for bsno = 1 upto nocards:
else:
 if unknown bsno:
   bsno := -1;
 fi;
fi;

 % select the strings for each card
 % after we're done, we set the middle square to `Free Square'
 % dups[] is used to keep track of already used values to eliminate
 % duplicates within each grid (a playing card has four grids on it)

 for bb = 1 upto 4:
    string bstring[];
    numeric dups[];

    for i = 1 upto 25:
      j := 1+floor(uniformdeviate bsmax);

      forever:
         exitif unknown dups[j];
         j := 1+floor(uniformdeviate bsmax);
      endfor;
      dups[j] := i;
      bstring[i] = bs[j];
    endfor;

    bstring[13] := "Free Square";

    bbcard[bb] := image(
      draw bbcard[0];
      for i = 1 upto 25:
         label(breaktowidth(bstring[i], 1.5cm, 11pt), bpos[i]);
      endfor;
    );
 endfor;

 beginfig(bsno);
  picture p;
  p := ("Political Bullshit Bingo" infont defaultfont scaled 2)
   shifted ((offset, 3offset)+2.25*ulcorner bbcard[0]);

  fill ((llcorner p)..(ulcorner p).. tension 2 .. (urcorner p)..
        (lrcorner p) .. tension 2 .. cycle)
   withcolor .5 white;
  draw p withcolor white;

  draw ("Special Reddit Edition" infont defaultfont scaled 1.2)
    shifted ((lrcorner p) + (10pt, 6pt));
  draw ("Stay alert for incoming memes!" infont defaultfont)
    shifted ((lrcorner p) + (10pt, -14pt));
  draw ("Get off your smartphone!" infont defaultfont)
    shifted ((lrcorner p) + (10pt, -25pt));
  draw ("Have fun!" infont defaultfont)
    shifted ((lrcorner p) + (10pt, -36pt));

  draw bbcard[1] shifted (offset, offset);
  draw bbcard[2] shifted ((1.25offset, offset)+lrcorner bbcard[0]);
  draw bbcard[3] shifted ((1.25offset, 2offset)+urcorner bbcard[0]);
  draw bbcard[4] shifted ((offset, 2offset)+ulcorner bbcard[0]);
 endfig;

if known nocards:
 endfor;
fi;

fi;
end;

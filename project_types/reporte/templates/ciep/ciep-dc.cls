%% $Id: ciep-dc.cls 49 2020-07-20 09:05:10$

 \def\RCSfile{ciep-dc}%
 \def\RCSversion{1.0}%
 \def\RCSdate{2020/07/18}%
\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{\RCSfile}[\RCSdate, \RCSversion: Formatting class
   for CIEP double column articles]
%
\def\ABD{\AtBeginDocument}
%
% switches
% 
\newif\iflongmktitle    \longmktitlefalse
\newif\ifdc             \global\dctrue
\newif\ifsc             \global\scfalse
\newif\ifcasreviewlayout  \global\casreviewlayoutfalse
\newif\ifcasfinallayout   \global\casfinallayoutfalse

\newcounter{blind}
\setcounter{blind}{0}

\def\blstr#1{\gdef\@blstr{#1}}
\def\@blstr{1}
\newdimen\@bls
\@bls=\baselineskip

\DeclareOption{singleblind}{\setcounter{blind}{1}}
\DeclareOption{doubleblind}{\setcounter{blind}{2}}
\DeclareOption{longmktitle}{\global\longmktitletrue}
\DeclareOption{final}{\global\casfinallayouttrue}
\DeclareOption{review}{\global\casreviewlayouttrue}

\ExecuteOptions{letterpaper,10pt,oneside,fleqn,review}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions
\LoadClass{article}

\RequirePackage{graphicx}
\RequirePackage{amsmath,amsfonts,amssymb}
\allowdisplaybreaks

\RequirePackage{expl3,xparse}
\@ifundefined{regex_match:nnTF}{\RequirePackage{l3regex}}{}
\RequirePackage{etoolbox,balance}
\RequirePackage{booktabs,makecell,multirow,array,colortbl,dcolumn,stfloats}
\RequirePackage{xspace,xstring,footmisc}
\RequirePackage[svgnames,dvipsnames]{xcolor}

\RequirePackage[colorlinks,hyperfootnotes=false]{hyperref}
\colorlet{scolor}{black}
\colorlet{hscolor}{DarkSlateGrey}
\hypersetup{%
  pdftitle={\csuse{__short_title:}},
  pdfauthor={\csuse{__short_authors:}},
  pdfcreator={LaTeX3; ciep-sc.cls; hyperref.sty},
  pdfproducer={pdfTeX;},
  linkcolor={hscolor},
  urlcolor={hscolor},
  citecolor={hscolor},
  filecolor={hscolor},
  menucolor={hscolor},
 }

 \let\comma\@empty
\let\tnotesep\@empty
\let\@title\@empty
%
% Load Common items
%

%Para evitar el overfull hbox del abstract
%\hbadness=10000
%\hfuzz=\maxdimen
%\newcount\hbadness
%\newdimen\hfuzz
\usepackage{etoolbox}% http://ctan.org/pkg/etoolbox
\newcommand{\ignoreoverfullhboxes}{\setlength{\hfuzz}{\maxdimen}}
\AtBeginEnvironment{Abstract}{\ignoreoverfullhboxes}

\RequirePackage{ciep-common}

%
% Specific to Single Column
%
\ExplSyntaxOn

\RenewDocumentCommand \maketitle { }
{
  \ifbool { usecasgrabsbox }
    { 
      \setcounter{page}{0}
      \thispagestyle{empty}
      \unvbox\casgrabsbox  
    } {}  
  \pagebreak  
  \ifbool { usecashlsbox }
    { 
      \setcounter{page}{0}
      \thispagestyle{empty}
      \unvbox\casauhlbox
    } {}    
  \pagebreak
  \thispagestyle{first}    
  \ifbool{longmktitle}
  {
    \LongMaketitleBox
    \ProcessLongTitleBox
  }
  {
    \twocolumn[\MaketitleBox]  
    \printFirstPageNotes
  }
  \setcounter{footnote}{\int_use:N \g_stm_fnote_int}
  \renewcommand\thefootnote{\arabic{footnote}}
  \gdef\@pdfauthor{\infoauthors}
  \gdef\@pdfsubject{Complex ~STM ~Content}
}

%
% Fonts
%
\RequirePackage[T1]{fontenc}

\file_if_exist:nTF { stix.sty }
{
  \file_if_exist:nTF { charis.sty }
  {
    \RequirePackage[notext]{stix} 
    \RequirePackage{charis}
  }
  { \RequirePackage{stix} }
}
{
  \iow_term:x {  *********************************************************** }
  \iow_term:x { ~Stix ~ and ~ Charis~ fonts ~ are ~ not ~ available ~ }
  \iow_term:x { ~ in ~TeX~system.~Hence~CMR~ fonts~ are ~ used. }
  \iow_term:x {  *********************************************************** }
}

\file_if_exist:nTF { inconsolata.sty }
{ \RequirePackage[scaled=.85]{inconsolata} }
{ \tex_gdef:D \ttdefault { cmtt } }


\ExplSyntaxOff

%
% Page geometry
%
\usepackage[%
   paperwidth=210mm,
   paperheight=280mm,
   vmargin={19.5mm,18.2mm},
   hmargin={18.1mm,18.1mm},
   headsep=12pt,
   footskip=12pt,
   columnsep=18pt
]{geometry}


\endinput
  
%
% End of class 'ciep-sc'
%
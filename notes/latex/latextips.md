# Latex Tips


A collectioin of Latex tips and tricks.


## Customize item label

    \usepackage{enumerate}
    \begin{enumerate}[A-1]
        \item ...
    \end{enumerate}


## Put watermark 

This will put watermark text such as draft on each page.

    \usepackage{draftwatermark}
    \SetWatermarkScale{0.5}


## Strike-through text

    \usepackage{ulem}
    \sout{will do my best}

## Define New Environment


Here is an example for a textbook that define an new environment called **exercise**, which will be have number associated with the chapter it is written in:


```
\newcounter{excounter}[chapter]
\renewcommand\theexcounter{\arabic{chapter}.\arabic{excounter}}
\newenvironment{exercise}{\medskip\noindent%
\refstepcounter{excounter}%
\textbf{Exercise \arabic{chapter}.\arabic{excounter}}%
\medskip%
}
```

Do note that how we have to `renewcommand\theexcounter`, which is a key to make the `\label{}` and `ref{}` to work properly.

## Add line numbers

In the preamble, the last line:

    \usepackage{lineno}

Right after `\begin{document}`

    \linenumbers
    \linenumbersep 3pt\relax
    
	


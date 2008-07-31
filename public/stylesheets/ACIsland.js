inslist = ["if", "else", "switch", "case", "default", "break", "goto", "return", "for", "while", "do", "continue", 
		   "typedef", "sizeof", "NULL"];
typelist = ["void", "struct", "union", "enum", "char", "short", "int", "long", "double", "float", "signed", "unsigned", 
			"const", "static", "extern", "auto", "register", "volatile"];
synlist = ["!", "?", ",", "(", ")", "[", "]", "{", "}", ":", ";", "+", "-", "*", /*"/", */"%", "|", "^", "&lt;", "&gt;", "&amp;"];
endStyle = "</span>";
function generateNode(name)
{
	document.write("");
}

function style(type)
{
	return "<span class=" + type + "Style>";
}

function color(buf)
{
	var i;
	buf = buf.replace(/=/g, style("syn") + '=' + endStyle);
	buf = buf.replace(/&lt;/g, "_$_");
	buf = buf.replace(/&gt;/g, "_@_");
	buf = buf.replace(/&amp;/g, "'");
	buf = buf.replace(/(\d+e-?\d+)/g, style("number") + "$1" + endStyle);
	for(i=0, lim=synlist.length; i<lim; i++)
	{
		regexp = new RegExp('\\' + synlist[i], "g");
		buf = buf.replace(regexp, style("syn") + synlist[i].charAt(synlist[i].length-1) + endStyle);
	}
	for(i=0, lim=inslist.length; i<lim; i++)
	{
		regexp = new RegExp('\\b' + inslist[i] + '\\b', "g");
		buf = buf.replace(regexp, style("ins") + inslist[i] + endStyle);
	}
	for(i=0, lim=typelist.length; i<lim; i++)
	{
		regexp = new RegExp('\\b' + typelist[i] + '\\b', "g");
		buf = buf.replace(regexp, style("type") + typelist[i] + endStyle);
	}
	buf = buf.replace(/(\d*\.?\d+)/g, style("number") + "$1" + endStyle);
	buf = buf.replace(/(\.[^\d\.]?)/g, function(word){return style("syn") + word.charAt(0) + endStyle + word.substr(1);});
	buf = buf.replace(/_\$_/g, style("syn") + "&lt;" + endStyle);
	buf = buf.replace(/_\@_/g, style("syn") + "&gt;" + endStyle);
	buf = buf.replace(/'/g, style("syn") + "&amp;" + endStyle);
	return buf;
}

function highlightC(buf)
{
	var i, lim, str, buf;
	if(buf.charAt(0) == '#')
	{
		return style("header") + buf + endStyle;
	}
	str = "";
	for(i=0, lim=buf.length; i<lim; i=nextPos)
	{
		temp1 = buf.substr(i).match(/^.*?[^\\]?'/);
		temp2 = buf.substr(i).match(/^.*?[^\\]?"/);
		if(temp1)
		{
			temp1 = temp1[0];
		}
		if(temp2)
		{
			temp2 = temp2[0];
		}
		if(temp1 == null && temp2 == null)
		{
			str += color(buf.substr(i));
			break;
		}
		else
		{
			if(temp2 == null || ((len1=temp1?temp1.length:2147483647) < (len2=temp2?temp2.length:2147483647)))
			{
				nextPos = i + len1;
				str += color(temp1.slice(i, -1));
				i = nextPos;
				temp1 = buf.substr(i).match(/^.*?[^\\]?'/);
				if(temp1 == null)
				{
					temp1 = buf.substr(i);
				}
				else
				{
					temp1 = temp1[0];
				}
				str += style("string") + "'" + temp1 + endStyle;
				nextPos += temp1.length;
			}
			else
			{
				nextPos = i + len2;
				str += color(temp2.slice(i, -1));
				i = nextPos;
				temp2 = buf.substr(i).match(/^.*?[^\\]?"/);
				if(temp2 == null)
				{
					temp2 = buf.substr(i);
				}
				else
				{
					temp2 = temp2[0];
				}
				str += style("string") + '"' + temp2 + endStyle;
				nextPos += temp2.length;
			}
		}
	}
	return str;
}

function parseC(field)
{
	var i;
	var lim;
	var ary;
	var buf;
	str = field.innerHTML;
	ary = str.split('\n');
	newfield = document.createElement("pre");
	newfield.setAttribute("class", "C");
	buf = "<ol>";
	for(i=0, lim=ary.length, flag=0; i<lim; i++)
	{
		if(flag == 0 && ary[i].charCodeAt(0) == 13)
		{
			continue;
		}
		flag = 1;
		buf += "<li>" + highlightC(ary[i]) + "</li>";
	}
	buf += "</ol>";
	newfield.innerHTML = buf;
	newfield.className = 'C';
	field.parentNode.replaceChild(newfield, field);
	document.write("Success!!");
}

function checkcode()
{
	var ary;
	ary = document.getElementsByTagName('textarea');
	for(i=0, lim=ary.length; i<lim; i++)
	{
		if(ary[i].className == 'C')
		{
			parseC(ary[i]);
		}
	}
}
nodeCounter = 0

inslist = ["if", "else", "switch", "case", "default", "break", "goto", "return", "for", "while", "do", "continue", 
		   "typedef", "sizeof", "NULL"];
typelist = ["void", "struct", "union", "enum", "char", "short", "int", "long", "double", "float", "signed", "unsigned", 
			"const", "static", "extern", "auto", "register", "volatile"];
synlist = ["!", "?", ",", "(", ")", "[", "]", "{", "}", ":", ";", "+", "-", "*", /*"/", */"%", "|", "^", "<", ">", "&"];
endStyle = "</span>";

function clickTab(name)
{
	list = document.getElementsByTagName('div')
	temp = name.split('_')[0] + 's'
	for(i=0, lim=list.length; i<lim; i++)
	{
		if(list[i].className == temp)
		{
			list[i].style.display = 'none';
		}
	}
	target = document.getElementById(name);
	target.style.display = 'block';
}

function clickNode(name)
{
	target = document.getElementById(name);
	if(target.style.display == '')
	{
		target.style.display = 'block';
	}
	else
	{
		target.style.display = '';
	}
}

function clickTab(ownName,divName)
{
	list = document.getElementsByTagName('a');
	temp = divName.split('_')[0] + '_tab';
	for(i=0, lim=list.length; i<lim; i++)
	{
		if(list[i].className == temp)
		{
			list[i].style.backgroundColor = 'black';
			list[i].style.borderColor = '#666666';
			list[i].style.borderBottomWidth = '0px';
			list[i].style.color = '#999999';
		}
	}
	list = document.getElementsByTagName('div')
	temp = divName.split('_')[0] + 's'
	for(i=0, lim=list.length; i<lim; i++)
	{
		if(list[i].className == temp)
		{
			list[i].style.display = 'none';
		}
	}
	ownTarget = document.getElementById(ownName);
	ownTarget.style.backgroundColor = '#333333';
	ownTarget.style.borderColor = 'palegoldenrod';
	ownTarget.style.borderBottomColor = '#333333';
	ownTarget.style.borderBottomWidth = '1px';
	ownTarget.style.color = 'lavender';
	divTarget = document.getElementById(divName);
	divTarget.style.display = '';
	divTarget.style.backgroundColor = '#333333';
	divTarget.style.borderColor = 'palegoldenrod';
}

function clickNode(listName,subListName,depth)
{
	subListTarget = document.getElementById(subListName);
	listTarget = document.getElementById(listName);
	if(subListTarget.style.display == '')
	{
		subListTarget.style.display = 'block';
		listTarget.style.border = '1px dashed yellow';
	}
	else
	{
		subListTarget.style.display = '';
		listTarget.style.border = '';
	}
}

function hideCat()
{
	document.getElementById("cat_hidden_link").style.display = "none";
	document.getElementById("cat_show_link").style.display = "";
	list = document.getElementsByTagName("div");
	for(i=0, lim=list.length; i<lim; i++)
	{
		if(list[i].className == 'show_cat_field')
		{
			list[i].style.display = "";
		}
	}
}

function showCat()
{
	document.getElementById("cat_hidden_link").style.display = "";
	document.getElementById("cat_show_link").style.display = "none";
	list = document.getElementsByTagName("div");
	for(i=0, lim=list.length; i<lim; i++)
	{
		if(list[i].className == 'show_cat_field')
		{
			list[i].style.display = "block";
		}
	}
}

function style(type)
{
	return "<span class=" + type + "Style>";
}

function color(buf)
{
	var i;
	buf = buf.replace(/=/g, style("syn") + '=' + endStyle);
	buf = buf.replace(/</g, "_$_");
	buf = buf.replace(/>/g, "_@_");
	buf = buf.replace(/&/g, "'");
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
	buf = buf.replace(/_\$_/g, style("syn") + "<" + endStyle);
	buf = buf.replace(/_\@_/g, style("syn") + ">" + endStyle);
	buf = buf.replace(/'/g, style("syn") + "&" + endStyle);
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
	for (i=0, lim=ary.length, flag=0; i<lim; i++)
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

/*Header color changing by Tommy*/
var hg=new Array("D7","D0","C7","C0","B7","B0","A7","A0","97","90","87","80","77","70","63",		      "70","77","80","87","90","97","A0","A7","B0","B7","C0","C7","D0");
var hb=new Array("00","04","07","10","14","17","20","24","27","30","34","37","40","44","47",
      "44","40","37","34","30","27","24","20","17","14","10","07","04");
var g=0,b=0,hc;
function ChangeHeader()
{
	g=(g+1)%28,b=(b+1)%28;
	hc="#FF"+hg[g]+hb[b];
	document.getElementById('header').style.color=hc;
}
/*show empty cells for IE*/
function ShowEmptyCells()
{
        if(navigator.appName=="Microsoft Internet Explorer")
        {
                var i,tdArray=document.getElementsByTagName("td");
                for(i=tdArray.length-1;i>=0;i--)
                        if(tdArray[i].innerHTML=='')tdArray[i].innerHTML+="&"+"nbsp;";
        }
}
/*----------------------LeftMenu-----------------------*/
<!--

	var tab="&"+"nbsp;"+"&nbs"+"p;&nbsp"+";&n"+"bsp;";
	var i,maxlevel=-1,tmp,totalfolder=0
	
	var Folder_State=new Array(50);
	var Display_State=new Array("none","block");
	var Folder_Mark=new Array("＋","－");
	
	//getCookie("F_S"); HERE HERE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	
	function make(flag,name,level,address)
	{
		if(maxlevel<level)maxlevel=level;
		else if(level<maxlevel)
			for(;maxlevel>level;maxlevel--)document.write("</div>");
		for(i=0;i<=level;i++)document.write(tab);
		if(flag=="node")
		{
			document.write("<a href=# name=A_Name@"+totalfolder+"\
							onclick=\"javascript:expand(document.getElementById('folder_"+totalfolder+
							"'));changemark(this);\">"+
							Folder_Mark[Folder_State[totalfolder]]+"</a><a href="+address+" target=main>"+
							name+"</a><br>");
			document.write("<div id=folder_"+totalfolder+" style=\"display: "+
							Display_State[Folder_State[totalfolder]]+";\">");
			totalfolder++;
		}
		else document.write("<a href="+address+" target=main>"+name+"</a><br>");
	}
	function expand(x)
	{
		obj=x;
		if(x.style.display=='block')
		{
			var j;
			for(i=10,j=0;i>=0;i--,j++)
				setTimeout("setOpacity("+i+")",15*j);
			setTimeout("changedis()",15*12);
		}	
		else
		{
			if(navigator.appName=="Microsoft Internet Explorer")
				x.style.filter="alpha(opacity=0)";
			else x.style.opacity=0;
			changedis();
			for(i=0;i<=10;i++)
				setTimeout("setOpacity("+i+")",30*i);
		}
	}
	function setOpacity(n)
	{
		if(navigator.appName=="Microsoft Internet Explorer")
			obj.style.filter="alpha(opacity="+n*10+")";
		else obj.style.opacity=n/10;
	}
	function changedis()
	{
		if(obj.style.display=="block")obj.style.display="none";
		else obj.style.display="block";
	}
	function changemark(x)
	{
		var tmp=Folder_State[unescape(x.name.substring(x.name.indexOf("@")+1,x.name.length))];
		Folder_State[x.name.substring(x.name.indexOf("@")+1,x.name.length)]=1-tmp;
		if(x.innerHTML=='＋')x.innerHTML='－';
		else if(x.innerHTML=='－')x.innerHTML='＋';
		setCookie("F_S");
	}
	function getCookie(Cookie_name)
	{
		var i,s=Cookie_name+"=",slen=s.length,clen=document.cookie.length;
		if(document.cookie.indexOf("#$")>=0)
		{
			for(i=0;i<clen;i++)
				if(document.cookie.substring(i,i+slen)==s)
				{
					var j,tlen=clen-(i+slen);
					for(j=0;j<tlen;j++)
						Folder_State[j]=document.cookie.charAt(i+slen+j+2);
					break;
				}
		}
		else for(i=0;i<50;i++)Folder_State[i]=0;
		//alert(document.cookie);
	}
	function setCookie(Cookie_name)
	{
		//alert("set"+Folder_State.toString().replace(/,/g,""));
		var date=new Date();
		date.setTime(date.getTime()+1000*60*60*24*30);
		document.cookie=Cookie_name+"=#$"+Folder_State.toString().replace(/,/g,"")+";expires="+date.toGMTString();
	}
	function delCookie(Cookie_name)
	{
		var date=new Date();
		date.setTime(date.getTime()-1);
		document.cookie=Cookie_name+"=;expires="+date.toGMTString();
	}
//->

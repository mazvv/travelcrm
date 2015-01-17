/*
 * ----------------------------------------------------------------------------
 * Package:     JS Date Format Patch
 * Version:     0.9.12
 * Date:        2012-07-06
 * Description: In lack of decent formatting ability of Javascript Date object,
 *              I have created this "patch" for the Date object which will add 
 *              "Date.format(dateObject, format)" static function, and the 
 *              "dateObject.toFormattedString(format)" member function.
 *              Along with the formatting abilities, I have also added the 
 *              following functions for parsing dates:
 *              "Date.parseFormatted(value, format)" - static function
 *              "dateObject.fromFormattedString(value, format)" - member 
 *              function
 * Author:      Miljenko Barbir
 * Author URL:  http://miljenkobarbir.com/
 * Repository:  http://github.com/barbir/js-date-format
 * ----------------------------------------------------------------------------
 * Copyright (c) 2010 Miljenko Barbir
 * Dual licensed under the MIT and GPL licenses.
 * ----------------------------------------------------------------------------
 */

(function(){

// extend the Javascript Date class with the "format" static function which will format
// the provided date object using the provided format string
Date.format = function (date, format)
{
	// get the helper functions object
	var formatLogic = Date.formatLogic;

	// check if the AM/PM option is used
	var isAmPm		= (format.indexOf("a") !== -1) || (format.indexOf("A") !== -1);

	// prepare all the parts of the date that can be used in the format
	var parts		= [];
	parts['d']		= date.getDate();
	parts['dd']		= formatLogic.pad(parts['d'], 2);
	parts['ddd']	= formatLogic.i18n.shortDayNames[date.getDay()];
	parts['dddd']	= formatLogic.i18n.dayNames[date.getDay()];
	parts['M']		= date.getMonth() + 1;
	parts['MM']		= formatLogic.pad(parts['M'], 2);
	parts['MMM']	= formatLogic.i18n.shortMonthNames[parts['M'] - 1];
	parts['MMMM']	= formatLogic.i18n.monthNames[parts['M'] - 1];
	parts['yyyy']	= date.getFullYear();
	parts['yyy']	= formatLogic.pad(parts['yyyy'], 2) + 'y';
	parts['yy']		= formatLogic.pad(parts['yyyy'], 2);
	parts['y']		= 'y';
	parts['H']		= date.getHours();
	parts['hh']		= formatLogic.pad(isAmPm ? formatLogic.convertTo12Hour(parts['H']) : parts['H'], 2);
	parts['h']		= isAmPm ? formatLogic.convertTo12Hour(parts['H']) : parts['H'];
	parts['HH']		= formatLogic.pad(parts['H'], 2);
	parts['m']		= date.getMinutes();
	parts['mm']		= formatLogic.pad(parts['m'], 2);
	parts['s']		= date.getSeconds();
	parts['ss']		= formatLogic.pad(parts['s'], 2);
	parts['z']		= date.getMilliseconds();
	parts['zz']		= parts['z'] + 'z';
	parts['zzz']	= formatLogic.pad(parts['z'], 3);
	parts['ap']		= parts['H'] < 12 ? 'AM' : 'PM';
	parts['a']		= parts['H'] < 12 ? 'AM' : 'PM';
	parts['AP']		= parts['H'] < 12 ? 'AM' : 'PM';
	parts['A']		= parts['H'] < 12 ? 'AM' : 'PM';

	// parse the input format, char by char
	var i = 0;
	var output = "";
	var token = "";
	while (i < format.length)
	{
		token = format.charAt(i);
		
		while((i + 1 < format.length) && parts[token + format.charAt(i + 1)] !== undefined)
		{
			token += format.charAt(++i);
		}

		if (parts[token] !== undefined)
		{
			output += parts[token];
		}
		else
		{
			output += token;
		}

		i++;
	}

	// return the parsed result
	return output;
};

// this is the format logic helper object that contains the helper functions
// and the internationalization settings that can be overridden
Date.formatLogic = 
{
	// left-pad the provided number with zeros
	pad: function (value, digits)
	{
		var max = 1;
		var zeros = "";

		if(digits < 1)
		{
			return "";
		}

		for(var i = 0; i < digits; i++)
		{
			max *= 10;
			zeros += "0";
		}

		var output = value;

		output = zeros + value;
		output = output.substring(output.length - digits);

		return output;
	},

	// convert the 24 hour style value to a 12 hour style value
	convertTo12Hour: function (value)
	{
		return value % 12 === 0 ? 12 : value % 12;
	},

	// internationalization settings
	i18n:
	{
		dayNames:			['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'],
		shortDayNames:		['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
		monthNames:			['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'],
		shortMonthNames:	['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
	}
};

// add a member "format" function which will return the string representation
// of the current object formatted using the provided format string
Date.prototype.toFormattedString = function (format)
{
	return Date.format(this, format);
};

// extend the Javascript Date class with the "parseFormatted" static function which
// will parse the provided string, using the provided format into a valid date object
Date.parseFormatted = function (value, format)
{
	var output		= new Date(2000, 0, 1);
	var parts		= [];
	parts['d']		= '([0-9][0-9]?)';
	parts['dd']		= '([0-9][0-9])';
//	parts['ddd']	= NOT SUPPORTED;
//	parts['dddd']	= NOT SUPPORTED;
	parts['M']		= '([0-9][0-9]?)';
	parts['MM']		= '([0-9][0-9])';
//	parts['MMM']	= NOT SUPPORTED;
//	parts['MMMM']	= NOT SUPPORTED;
	parts['yyyy']	= '([0-9][0-9][0-9][0-9])';
	parts['yyy']	= '([0-9][0-9])[y]';
	parts['yy']		= '([0-9][0-9])';
	parts['H']		= '([0-9][0-9]?)';
	parts['hh']		= '([0-9][0-9])';
	parts['h']		= '([0-9][0-9]?)';
	parts['HH']		= '([0-9][0-9])';
	parts['m']		= '([0-9][0-9]?)';
	parts['mm']		= '([0-9][0-9])';
	parts['s']		= '([0-9][0-9]?)';
	parts['ss']		= '([0-9][0-9])';
	parts['z']		= '([0-9][0-9]?[0-9]?)';
	parts['zz']		= '([0-9][0-9]?[0-9]?)[z]';
	parts['zzz']	= '([0-9][0-9][0-9])';
	parts['ap']		= '([AP][M])';
	parts['a']		= '([AP][M])';
	parts['AP']		= '([AP][M])';
	parts['A']		= '([AP][M])';

	var _ = Date.parseLogic;

	// parse the input format, char by char
	var i = 0;
	var regex = "";
	var outputs = new Array("");
	var token = "";

	// parse the format to get the extraction regex
	while (i < format.length)
	{
		token = format.charAt(i);
		while((i + 1 < format.length) && parts[token + format.charAt(i + 1)] !== undefined)
		{
			token += format.charAt(++i);
		}

		if (parts[token] !== undefined)
		{
			regex += parts[token];
			outputs[outputs.length] = token;
		}
		else
		{
			regex += token;
		}

		i++;
	}

	// extract matches
	var r = new RegExp(regex);
	var matches = value.match(r);

	if(matches === undefined || matches.length !== outputs.length)
	{
		return undefined;
	}

	// parse each match and update the output date object
	for(i = 0; i < outputs.length; i++)
	{
		if(outputs[i] !== '')
		{
			switch(outputs[i])
			{
				case 'yyyy':
				case 'yyy':
					output.setYear(_.parseInt(matches[i]));
					break;

				case 'yy':
					output.setYear(2000 + _.parseInt(matches[i]));
					break;

				case 'MM':
				case 'M':
					output.setMonth(_.parseInt(matches[i]) - 1);
					break;

				case 'dd':
				case 'd':
					output.setDate(_.parseInt(matches[i]));
					break;

				case 'hh':
				case 'h':
				case 'HH':
				case 'H':
					output.setHours(_.parseInt(matches[i]));
					break;

				case 'mm':
				case 'm':
					output.setMinutes(_.parseInt(matches[i]));
					break;

				case 'ss':
				case 's':
					output.setSeconds(_.parseInt(matches[i]));
					break;

				case 'zzz':
				case 'zz':
				case 'z':
					output.setMilliseconds(_.parseInt(matches[i]));
					break;

				case 'AP':
				case 'A':
				case 'ap':
				case 'a':
					if((matches[i] === 'PM' || matches[i] === 'pm') && (output.getHours() < 12))
					{
						output.setHours(output.getHours() + 12);
					}

					if((matches[i] === 'AM' || matches[i] === 'am') && (output.getHours() === 12))
					{
						output.setHours(0);
					}
					break;
			}
		}
	}

	return output;
};

// this is the parse logic helper object that contains the helper functions
Date.parseLogic = 
{
	unpad: function (value)
	{
		var output = value;

		while(output.length > 1)
		{
			if(output[0] === '0')
			{
				output = output.substring(1, output.length);
			}
			else
			{
				break;
			}
		}

		return output;
	},
	parseInt: function (value)
	{
		return parseInt(this.unpad(value), 10);
	}
};

// add a member "from" function which will return the date object, created
// from the provided string and the format
Date.prototype.fromFormattedString = function(value, format)
{
	this.setTime(Date.parseFormatted(value, format).getTime());
	return this;
};

})();

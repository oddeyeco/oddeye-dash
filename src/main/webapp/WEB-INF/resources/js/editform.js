/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


/* global PicerOptionSet2, getParameterByName, colorPalette, chartForm, jsonmaker, editor, cp, locale */

class EditForm {

    constructor(formwraper, row, index, dashJSON, aftermodifier = null) {
        this.aftermodifier = aftermodifier;
        this.deflist = {};
        this.formwraper = formwraper;
        this.row = row;
        this.index = index;
        this.dashJSON = dashJSON;
        this.inittabcontent();
        var checked = false;
        if (this.dashJSON.rows[this.row]["widgets"][this.index].manual)
        {
            checked = this.dashJSON.rows[this.row]["widgets"][this.index].manual;
        }

        this.formwraper.append('<div class="float-right tabcontrol"><label class="control-label" >' + locale["editform.jsonManualEdit"] + '</label>' +
                '<div class="checkbox" style="display: inline-block">' +
                '<input type="checkbox" class="js-switch-small"  chart_prop_key="manual" id="manual" name="manual" key_path="manual" /> ' +
                '</div> '
                );
        if (checked)
        {
            this.formwraper.find('#manual').attr("checked", checked);
        } else
        {
            this.formwraper.find('#manual').removeAttr("checked");
        }
        var jobject = this.formwraper.find('#manual');
        if (jobject.hasClass("js-switch-small"))
        {
            var ob_form = this;
            var elem = document.getElementById(jobject.attr('id'));
            new Switchery(elem, {size: 'small', color: clr, jackColor: jackClr, secondaryColor: secClr, jackSecondaryColor: jackSecClr});
            elem.onchange = function () {
                ob_form.change($(this));
            };
        }

        this.formwraper.append('<div role="tabpanel" id="tabpanel">');
        this.formwraper.find('#tabpanel').append('<nav id="nav-editTab" class="nav-tabs pl-sm-5 pl-sm-2 p-0"><ul id="formTab" class="nav bar_tabs" role="tablist"></nav>');
        this.formwraper.find('#tabpanel').append('<div id="TabContent" class="card-body tab-content" >');
        var tabs = this.gettabs();
        for (var key in tabs)
        {
            var tab = tabs[key];
            this.formwraper.find('#tabpanel #formTab').append('<li role="presentation"><a class="nav-item nav-link" href="#' + tab.contentid + '" id="' + tab.id + '" role="tab" data-toggle="tab">' + tab.title + '</a>');
            this.formwraper.find('#tabpanel #TabContent').append('<div role="tabpanel" class="tab-pane fade" id="' + tab.contentid + '" aria-labelledby="' + tab.id + '"> ');
//            console.log(this.gettabcontent(tab.contentid));
            if (this.gettabcontent(tab.contentid))
            {
                var content = this.gettabcontent(tab.contentid);
                if (content.active)
                {
//                    this.formwraper.find('#tabpanel #formTab #' + tab.id).parent().addClass('active');
                    this.formwraper.find('#tabpanel #formTab #' + tab.id).addClass('active');
                    this.formwraper.find('#tabpanel #TabContent #' + tab.contentid).addClass('show active');
                }
                this.formwraper.find('#tabpanel #TabContent #' + tab.contentid).append('<div class="row">');
                var contenttab = this.formwraper.find('#tabpanel #TabContent #' + tab.contentid + ' div');
                if (content.forms)
                {
                    for (var f_key in content.forms)
                    {
                        var form = content.forms[f_key];
                        contenttab.append('<' + form.tag + ' class="' + form.class + '" id="' + form.id + '"><div class="form_main_block">');
                        if (form.label)
                        {
                            if (form.label.show)
                            {
                                contenttab.find('#' + form.id + ' .form_main_block').append('<h3><label class="control-label" >' + form.label.text + '</label></h3>');
                                if (form.label.checker)
                                {
                                    contenttab.find('#' + form.id + ' .form_main_block h3').append('<div class="checkbox" style="display: inline-block">' +
                                            '<' + form.label.checker.tag + ' type="' + form.label.checker.type + '" class="' + form.label.checker.class + '" prop_key="' + form.label.checker.prop_key + '" id="' + form.label.checker.id + '" name="' + form.label.checker.name + '"' + '" key_path="' + form.label.checker.key_path + '" /> ' +
                                            '</div>');
                                    checked = this.getvaluebypath(form.label.checker.key_path, form.label.checker.default);
                                    if (checked)
                                    {
                                        contenttab.find('#' + form.label.checker.id).attr("checked", checked);
                                    } else
                                    {
                                        contenttab.find('#' + form.label.checker.id).removeAttr("checked");
                                    }


                                    var jobject = contenttab.find('#' + form.label.checker.id);
                                    if (jobject.hasClass("js-switch-small"))
                                    {
                                        var ob_form = this;
                                        var elem = document.getElementById(jobject.attr('id'));
                                        new Switchery(elem, {size: 'small', color: clr, jackColor: jackClr, secondaryColor: secClr, jackSecondaryColor: jackSecClr});
                                        elem.onchange = function () {
                                            ob_form.change($(this));
                                        };
                                    }
                                }
                            }

                        }
                        var formcontent = form.content;
                        var contener = contenttab.find('#' + form.id + ' .form_main_block');
                        this.drawcontent(formcontent, contener);
                    }
                }

            }

    }

    }
    drawcontent(formcontent, contener, initval, template_index)
    {
        if (formcontent)
        {
            for (var c_index in formcontent)
            {
                var item = formcontent[c_index];
                if (item.tag)
                {
                    var jobject = $('<' + item.tag + '/>');
                    if (item.tag === "select")
                    {
                        if (item.options)
                        {
                            for (var opt_key in item.options)
                            {

                                if (typeof (item.options[opt_key]) === "object")
                                {
                                    if (item.options[opt_key].label)
                                    {
                                        var group = $('<optgroup label="' + item.options[opt_key].label + '">');
                                        for (var optgroup_key in item.options[opt_key].items)
                                        {
                                            group.append('<option value="' + optgroup_key.trim() + '">' + item.options[opt_key].items[optgroup_key] + '</option>');
                                        }
                                        jobject.append(group);
                                    }

                                } else
                                {
                                    jobject.append('<option value="' + opt_key.trim() + '">' + item.options[opt_key] + '</option>');
                                }

                            }

                        }
                    }
                    if (item.class)
                    {
                        jobject.addClass(item.class);
                    }
                    if (item.text)
                    {
                        jobject.html(item.text);
                    }
                    if (item.lfor)
                    {
                        jobject.attr('for', item.lfor);
                    }
                    if (item.target)
                    {
                        jobject.attr('target', item.target);
                    }
                    if (item.id)
                    {
                        var tmpval = item.id;
                        if (template_index)
                        {
                            tmpval = tmpval.replace("{index}", template_index);
                            jobject.attr('template_index', template_index);
                        }
                        jobject.attr('id', tmpval);
                    }
                    if (item.type)
                    {
                        jobject.attr('type', item.type);
                    }
                    if (typeof (item.min) !== "undefined")
                    {
                        jobject.attr('min', item.min);
                    }
                    if (typeof (item.max) !== "undefined")
                    {
                        jobject.attr('max', item.max);
                    }
                    if (item.prop_key)
                    {
                        jobject.attr('prop_key', item.prop_key);
                    }
                    if (item.placeholder)
                    {
                        jobject.attr('placeholder', item.placeholder);
                    }



                    if (item.name)
                    {
                        jobject.attr('name', item.name);
                    }
                    if (item.style)
                    {
                        jobject.attr('style', item.style);
                    }
//***************************
                    if (item.label)
                    {
                        jobject.append('<h4 class="form-group ' + item.label.class + '"><label class="control-label" >' + item.label.text + '</label></h4>');
                    }

//***************************



                    var form = this;

                    if (item.key_path)
                    {
                        jobject.attr('key_path', item.key_path);
                        if (item.type === 'checkbox')
                        {

                            var check = this.getvaluebypath(item.key_path, item.default, initval);
                            if (check)
                            {
                                jobject.attr("checked", check);
                            } else
                            {
                                jobject.removeAttr("checked");
                            }
                        } else if (item.type === 'split_string')
                        {
                            if (this.getvaluebypath(item.key_path, item.default, initval))
                            {
                                var vars = this.getvaluebypath(item.key_path, item.default, initval).split(item.split);
                                for (var varsindex in vars)
                                {
                                    if (vars[varsindex] !== "")
                                    {
                                        jobject.append("<span class='control-label tag_label " + item.prop_key + "' ><span class='tagspan'><span class='text'>" + vars[varsindex] + "</span><a><i class='fa fas fa-pencil-alt'></i> </a> <a><i class='fa fas fa-times'></i></a></span></span>");
                                    }
                                }
                            }

                        } else if (item.type === 'choose_array')
                        {
                            if (this.getvaluebypath(item.init_key_path, item.default))
                            {
                                var vars = this.getvaluebypath(item.init_key_path, item.default);
                                var values = this.getvaluebypath(item.key_path, item.default, initval);
                                for (var varsindex in vars)
                                {
                                    if (vars[varsindex] !== "")
                                    {
                                        var checked = "";
                                        if ($.isArray(values))
                                        {
                                            if (values.indexOf(parseInt(varsindex)) > -1)
                                            {
                                                checked = "checked=true";
                                            }
                                        } else
                                        {
                                            var ivarsindex = parseInt(varsindex);
                                            if (values === ivarsindex)
                                            {
                                                checked = "checked=true";
                                            }
                                        }
                                        if (!item.choose_type)
                                        {
                                            item.choose_type = "checkbox";
                                        }
                                        jobject.append("<span>" + varsindex + '<input type="' + item.choose_type + '" index="' + varsindex + '" class="flat", name="' + item.name + '[]" ' + checked + ' />');

                                    }
                                }
                                jobject.find('input.flat').on('ifToggled', function () {
                                    form.change($(this).parents('[type=choose_array]'));
                                });
                            }

                        } else
                        {
                            if (typeof (this.getvaluebypath(item.key_path, item.default, initval)) === 'object')
                            {
                                if (item.template)
                                {
                                    contener.attr('key_path', item.key_path);
                                    var val = this.getvaluebypath(item.key_path, item.default, initval);
                                    for (var qindex in val)
                                    {
                                        this.drawcontent(item.template, contener, val[qindex], qindex);
                                    }


                                }
                            } else
                            {
                                jobject.val(this.getvaluebypath(item.key_path, item.default, initval));
                            }


                        }

                        if (item.tag === 'span')
                        {
                            jobject.html(this.getvaluebypath(item.key_path, item.default, initval));
                        }

                    }

                    if (item.actions)
                    {

                        for (var a_index in item.actions)
                        {
                            if (typeof (item.actions[a_index]) === "function")
                            {
                                jobject.on(a_index, item.actions[a_index]);
                            }

                        }
                    }

                    jobject.appendTo(contener);

                    if (item.info)
                    {
                        if (item.info.text)
                        {
                            jobject.append(' <i class="fa fas fa-info-circle" data-toggle="tooltip" data-placement="top" title="' + item.info.text + '">');
                        }
                    }

                    if (item.check_dublicates)
                    {
                        item.check_dublicates(contener, this.getvaluebypath(item.key_path, item.default, initval));
                    }

                    if (jobject.hasClass("js-switch-small"))
                    {
                        var elem = document.getElementById(jobject.attr('id'));
                        new Switchery(elem, {size: 'small', color: clr, jackColor: jackClr, secondaryColor: secClr, jackSecondaryColor: jackSecClr});
                        elem.onchange = function () {
                            form.change($(this));
                        };
                    }

                    if (item.content)
                    {
                        this.drawcontent(item.content, jobject, initval, template_index);
                    }
//                    else
//                    {
//                        if (item.id=="valod")
//                        {
//                        console.log(item.);    
//                        }
//                        
//                    }
                }

            }
        }
    }
    get targetoptions()
    {
        return {"": "&nbsp;", "self": locale["editform.self"], "blank": locale["editform.blank"]};
    }

    get visualMaporientoptions()
    {        
        return {"horizontal": locale["editchartform.horizontal"], "vertical": locale["editchartform.vertical"]};
    }

    get visualMapColoroptions()
    {
        return {
            "": "Default",
            "Grade Grey": "Grade Grey",
            "Piggy Pink": "Piggy Pink",
            "Cool Blues": "Cool Blues",
            "MegaTron": "MegaTron",
            "Moonlit Asteroid": "Moonlit Asteroid",
            "JShine": "JShine",
            "Evening Sunshine": "Evening Sunshine",
            "Dark Ocean": "Dark Ocean",
            "Cool Sky": "Cool Sky",
            "Yoda": "Yoda",
            "Memariani": "Memariani",
            "Amin": "Amin",
            "Harvey": "Harvey",
            "Neuromancer": "Neuromancer",
            "Azur Lane": "Azur Lane",
            "Witching Hour": "Witching Hour",
            "Flare": "Flare",
            "Metapolis": "Metapolis",
            "Kyoo Pal": "Kyoo Pal",
            "Kye Meh": "Kye Meh",
            "Kyoo Tah": "Kyoo Tah",
            "By Design": "By Design",
            "Ultra Voilet": "Ultra Voilet",
            "Burning Orange": "Burning Orange",
            "Wiretap": "Wiretap",
            "Summer Dog": "Summer Dog",
            "Rastafari": "Rastafari",
            "Sin City Red": "Sin City Red",
            "Citrus Peel": "Citrus Peel",
            "Blue Raspberry": "Blue Raspberry",
            "Margo": "Margo",
            "Magic": "Magic",
            "Evening Night": "Evening Night",
            "Vanusa": "Vanusa",
            "Shifty": "Shifty",
            "eXpresso": "eXpresso",
            "Slight Ocean View": "Slight Ocean View",
            "Pure Lust": "Pure Lust",
            "Moon Purple": "Moon Purple",
            "Red Sunset": "Red Sunset",
            "Shifter": "Shifter",
            "Wedding Day Blues": "Wedding Day Blues",
            "Sand to Blue": "Sand to Blue",
            "Quepal": "Quepal",
            "Pun Yeta": "Pun Yeta",
            "Sublime Light": "Sublime Light",
            "Sublime Vivid": "Sublime Vivid",
            "Bighead": "Bighead",
            "Taran Tado": "Taran Tado",
            "Relaxing red": "Relaxing red",
            "Lawrencium": "Lawrencium",
            "Ohhappiness": "Ohhappiness",
            "Delicate": "Delicate",
            "Selenium": "Selenium",
            "Sulphur": "Sulphur",
            "Pink Flavour": "Pink Flavour",
            "Rainbow Blue": "Rainbow Blue",
            "Orange Fun": "Orange Fun",
            "Digital Water": "Digital Water",
            "Lithium": "Lithium",
            "Argon": "Argon",
            "Hydrogen": "Hydrogen",
            "Zinc": "Zinc",
            "Velvet Sun": "Velvet Sun",
            "King Yna": "King Yna",
            "Summer": "Summer",
            "Orange Coral": "Orange Coral",
            "Purpink": "Purpink",
            "Dull": "Dull",
            "Kimoby Is The New Blue": "Kimoby Is The New Blue",
            "Broken Hearts": "Broken Hearts",
            "Subu": "Subu",
            "Socialive": "Socialive",
            "Crimson Tide": "Crimson Tide",
            "Telegram": "Telegram",
            "Terminal": "Terminal",
            "Scooter": "Scooter",
            "Alive": "Alive",
            "Relay": "Relay",
            "Meridian": "Meridian",
            "Compare Now": "Compare Now",
            "Mello": "Mello",
            "Crystal Clear": "Crystal Clear",
            "Visions of Grandeur": "Visions of Grandeur",
            "Chitty Chitty Bang Bang": "Chitty Chitty Bang Bang",
            "Blue Skies": "Blue Skies",
            "Sunkist": "Sunkist",
            "Coal": "Coal",
            "Html": "Html",
            "Cinnamint": "Cinnamint",
            "Maldives": "Maldives",
            "Mini": "Mini",
            "Sha la la": "Sha la la",
            "Purplepine": "Purplepine",
            "Celestial": "Celestial",
            "Learning and Leading": "Learning and Leading",
            "Pacific Dream": "Pacific Dream",
            "Venice": "Venice",
            "Orca": "Orca",
            "Love and Liberty": "Love and Liberty",
            "Very Blue": "Very Blue",
            "Can You Feel The Love Tonight": "Can You Feel The Love Tonight",
            "The Blue Lagoon": "The Blue Lagoon",
            "Under the Lake": "Under the Lake",
            "Honey Dew": "Honey Dew",
            "Roseanna": "Roseanna",
            "What lies Beyond": "What lies Beyond",
            "Rose Colored Lenses": "Rose Colored Lenses",
            "EasyMed": "EasyMed",
            "Cocoaa Ice": "Cocoaa Ice",
            "Jodhpur": "Jodhpur",
            "Jaipur": "Jaipur",
            "Vice City": "Vice City",
            "Mild": "Mild",
            "Dawn": "Dawn",
            "Ibiza Sunset": "Ibiza Sunset",
            "Radar": "Radar",
            "80's Purple": "80's Purple",
            "Black Rosé": "Black Rosé",
            "Brady Brady Fun Fun": "Brady Brady Fun Fun",
            "Ed's Sunset Gradient": "Ed's Sunset Gradient",
            "Snapchat": "Snapchat",
            "Cosmic Fusion": "Cosmic Fusion",
            "Nepal": "Nepal",
            "Azure Pop": "Azure Pop",
            "Love Couple": "Love Couple",
            "Disco": "Disco",
            "Limeade": "Limeade",
            "Dania": "Dania",
            "50 Shades of Grey": "50 Shades of Grey",
            "Jupiter": "Jupiter",
            "IIIT Delhi": "IIIT Delhi",
            "Sun on the Horizon": "Sun on the Horizon",
            "Blood Red": "Blood Red",
            "Sherbert": "Sherbert",
            "Firewatch": "Firewatch",
            "Lush": "Lush",
            "Frost": "Frost",
            "Mauve": "Mauve",
            "Royal": "Royal",
            "Minimal Red": "Minimal Red",
            "Dusk": "Dusk",
            "Deep Sea Space": "Deep Sea Space",
            "Grapefruit Sunset": "Grapefruit Sunset",
            "Sunset": "Sunset",
            "Solid Vault": "Solid Vault",
            "Bright Vault": "Bright Vault",
            "Politics": "Politics",
            "Sweet Morning": "Sweet Morning",
            "Sylvia": "Sylvia",
            "Transfile": "Transfile",
            "Tranquil": "Tranquil",
            "Red Ocean": "Red Ocean",
            "Shahabi": "Shahabi",
            "Alihossein": "Alihossein",
            "Ali": "Ali",
            "Purple White": "Purple White",
            "Colors Of Sky": "Colors Of Sky",
            "Decent": "Decent",
            "Deep Space": "Deep Space",
            "Dark Skies": "Dark Skies",
            "Suzy": "Suzy",
            "Superman": "Superman",
            "Nighthawk": "Nighthawk",
            "Forest": "Forest",
            "Miami Dolphins": "Miami Dolphins",
            "Minnesota Vikings": "Minnesota Vikings",
            "Christmas": "Christmas",
            "Joomla": "Joomla",
            "Pizelex": "Pizelex",
            "Haikus": "Haikus",
            "Pale Wood": "Pale Wood",
            "Purplin": "Purplin",
            "Inbox": "Inbox",
            "Blush": "Blush",
            "Back to the Future": "Back to the Future",
            "Poncho": "Poncho",
            "Green and Blue": "Green and Blue",
            "Light Orange": "Light Orange",
            "Netflix": "Netflix",
            "Little Leaf": "Little Leaf",
            "Deep Purple": "Deep Purple",
            "Back To Earth": "Back To Earth",
            "Master Card": "Master Card",
            "Clear Sky": "Clear Sky",
            "Passion": "Passion",
            "Timber": "Timber",
            "Between Night and Day": "Between Night and Day",
            "Sage Persuasion": "Sage Persuasion",
            "Lizard": "Lizard",
            "Piglet": "Piglet",
            "Dark Knight": "Dark Knight",
            "Curiosity blue": "Curiosity blue",
            "Ukraine": "Ukraine",
            "Green to dark": "Green to dark",
            "Fresh Turboscent": "Fresh Turboscent",
            "Koko Caramel": "Koko Caramel",
            "Virgin America": "Virgin America",
            "Portrait": "Portrait",
            "Turquoise flow": "Turquoise flow",
            "Vine": "Vine",
            "Flickr": "Flickr",
            "Instagram": "Instagram",
            "Atlas": "Atlas",
            "Twitch": "Twitch",
            "Pastel Orange at the Sun": "Pastel Orange at the Sun",
            "Endless River": "Endless River",
            "Predawn": "Predawn",
            "Purple Bliss": "Purple Bliss",
            "Talking To Mice Elf": "Talking To Mice Elf",
            "Hersheys": "Hersheys",
            "Crazy Orange I": "Crazy Orange I",
            "Between The Clouds": "Between The Clouds",
            "Metallic Toad": "Metallic Toad",
            "Martini": "Martini",
            "Friday": "Friday",
            "ServQuick": "ServQuick",
            "Behongo": "Behongo",
            "SoundCloud": "SoundCloud",
            "Facebook Messenger": "Facebook Messenger",
            "Shore": "Shore",
            "Cheer Up Emo Kid": "Cheer Up Emo Kid",
            "Amethyst": "Amethyst",
            "Man of Steel": "Man of Steel",
            "Neon Life": "Neon Life",
            "Teal Love": "Teal Love",
            "Red Mist": "Red Mist",
            "Starfall": "Starfall",
            "Dance To Forget": "Dance To Forget",
            "Parklife": "Parklife",
            "Cherryblossoms": "Cherryblossoms",
            "Ash": "Ash",
            "Virgin": "Virgin",
            "Earthly": "Earthly",
            "Dirty Fog": "Dirty Fog",
            "The Strain": "The Strain",
            "Reef": "Reef",
            "Candy": "Candy",
            "Autumn": "Autumn",
            "Nelson": "Nelson",
            "Winter": "Winter",
            "Forever Lost": "Forever Lost",
            "Almost": "Almost",
            "Moor": "Moor",
            "Aqualicious": "Aqualicious",
            "Misty Meadow": "Misty Meadow",
            "Kyoto": "Kyoto",
            "Sirius Tamed": "Sirius Tamed",
            "Jonquil": "Jonquil",
            "Petrichor": "Petrichor",
            "A Lost Memory": "A Lost Memory",
            "Vasily": "Vasily",
            "Blurry Beach": "Blurry Beach",
            "Namn": "Namn",
            "Day Tripper": "Day Tripper",
            "Pinot Noir": "Pinot Noir",
            "Miaka": "Miaka",
            "Army": "Army",
            "Shrimpy": "Shrimpy",
            "Influenza": "Influenza",
            "Calm Darya": "Calm Darya",
            "Bourbon": "Bourbon",
            "Stellar": "Stellar",
            "Clouds": "Clouds",
            "Moonrise": "Moonrise",
            "Peach": "Peach",
            "Dracula": "Dracula",
            "Mantle": "Mantle",
            "Titanium": "Titanium",
            "Opa": "Opa",
            "Sea Blizz": "Sea Blizz",
            "Midnight City": "Midnight City",
            "Mystic": "Mystic",
            "Shroom Haze": "Shroom Haze",
            "Moss": "Moss",
            "Bora Bora": "Bora Bora",
            "Venice Blue": "Venice Blue",
            "Electric Violet": "Electric Violet",
            "Kashmir": "Kashmir",
            "Steel Gray": "Steel Gray",
            "Mirage": "Mirage",
            "Juicy Orange": "Juicy Orange",
            "Mojito": "Mojito",
            "Cherry": "Cherry",
            "Pinky": "Pinky",
            "Sea Weed": "Sea Weed",
            "Stripe": "Stripe",
            "Purple Paradise": "Purple Paradise",
            "Sunrise": "Sunrise",
            "Aqua Marine": "Aqua Marine",
            "Aubergine": "Aubergine",
            "Bloody Mary": "Bloody Mary",
            "Mango Pulp": "Mango Pulp",
            "Frozen": "Frozen",
            "Rose Water": "Rose Water",
            "Horizon": "Horizon",
            "Monte Carlo": "Monte Carlo",
            "Lemon Twist": "Lemon Twist",
            "Emerald Water": "Emerald Water",
            "Intuitive Purple": "Intuitive Purple",
            "Green Beach": "Green Beach",
            "Sunny Days": "Sunny Days",
            "Playing with Reds": "Playing with Reds",
            "Harmonic Energy": "Harmonic Energy",
            "Cool Brown": "Cool Brown",
            "YouTube": "YouTube",
            "Noon to Dusk": "Noon to Dusk",
            "Hazel": "Hazel",
            "Nimvelo": "Nimvelo",
            "Sea Blue": "Sea Blue",
            "Blooker20": "Blooker20",
            "Sexy Blue": "Sexy Blue",
            "Purple Love": "Purple Love",
            "DIMIGO": "DIMIGO",
            "Skyline": "Skyline",
            "Sel": "Sel",
            "Sky": "Sky",
            "Petrol": "Petrol",
            "Anamnisar": "Anamnisar",
            "Copper": "Copper",
            "Royal Blue + Petrol": "Royal Blue + Petrol",
            "Royal Blue": "Royal Blue",
            "Windy": "Windy",
            "Rea": "Rea",
            "Bupe": "Bupe",
            "Mango": "Mango",
            "Reaqua": "Reaqua",
            "Lunada": "Lunada",
            "Bluelagoo": "Bluelagoo",
            "Anwar": "Anwar",
            "Combi": "Combi",
            "Ver Black": "Ver Black",
            "Ver": "Ver",
            "Blu": "Blu"
        };
    }

    get xpositionoptions()
    {       
        return {"": "&nbsp;",            
            "center": locale["editchartform.center"],
            "left": locale["editchartform.left"],
            "right": locale["editchartform.right"]            
        };
    }
    get ypositionoptions()
    {
        return {"": "&nbsp;", "center": locale["editchartform.center"], "top": locale["editchartform.top"], "bottom": locale["editchartform.bottom"]};
    }
    get spanoptions()
    {
        var obj = {};
        for (var i = 1; i < 13; i++) {
            obj[i] = i;
        }
        return obj;
    }

    get units()
    {
        return {none: {label: "None", items: {"": "None"
                    , "format_metric": "Short"
                    , "{value} %": "Percent(0-100)"
                    , "format100": "Percent(0.0-1.0)"
                    , "{value} %H": "Humidity(%H)"
                    , "{value} ppm": "PPM"
                    , "{value} dB": "Decible"
                    , "formathexadecimal0": "Hexadecimal(0x)"
                    , "formathexadecimal": "Hexadecimal"
                }},
            currency: {label: locale["editform.currency"], items: {"$ {value}": "Dollars ($)"
                    , "£ {value}": "Pounds (£)"
                    , "€ {value}": "Euro (€)"
                    , "¥ {value}": "Yen (¥)"
                    , "{value} руб.": "Rubles (руб)"

                }},
            time: {label: locale["editchartform.time"], items: {"formathertz": "Hertz (1/s)"
                    , "timens": "Nanoseconds (ns)"
                    , "timemicros": "microseconds (µs)"
                    , "timems": "Milliseconds (ms)"
                    , "timesec": "Seconds (s)"
                    , "timemin": "Minutes (m)"
                    , "timeh": "Hours (h)"
                    , "timed": "Days d"
                }},
            dataiec: {label: locale["editform.dataIEC"], items: {"dataBit": "Bits"
                    , "dataBytes": "Bytes"
                    , "dataKiB": "Kibibytes"
                    , "dataMiB": "Mebibytes"
                    , "dataGiB": "Gibibytes"
                }},
            data_metric: {label: locale["editform.dataMetric"], items: {"dataBitmetric": "Bits"
                    , "dataBytesmetric": "Bytes"
                    , "dataKiBmetric": "Kilobytes"
                    , "dataMiBmetric": "Megabytes"
                    , "dataGiBmetric": "Gigabytes"
                }},
            datarate: {label: locale["editform.dataRate"], items: {"formatPpS": "Packets/s"
                    , "formatbpS": "Bits/s"
                    , "formatBpS": "Bytes/s"
                    , "formatKbpS": "Kilobits/s"
                    , "formatKBpS": "Kilobytes/s"
                    , "formatMbpS": "Megabits/s"
                    , "formatMBpS": "Megabytes/s"
                    , "formatGBbpS": "Gigabits/s"
                    , "formatGBpS": "Gigabytes/s"
                }},
            Throughput: {
                label: locale["editform.throughput"],
                items: {
                    "formatops": "Ops/sec (ops)",
                    "formatrps": "Reads/sec (rps)",
                    "formatwps": "Writes/sec (wps)",
                    "formatiops": "I/O Ops/sec (iops)",
                    "formatopm": "Ops/min (opm)",
                    "formatrpm": "Reads/min (rpm)",
                    "formatwpm": "Writes/min (wpm)"
                }
            },
            Lenght: {
                label: locale["editform.lenght"],
                items: {
                    "formatmm": "Millimeter (mm)",
                    "formatm": "Meter (m)",
                    "formatkm": "Kilometer (km)",
                    "{value} mi": "Mile (mi)"
                }
            },
            Velocity: {
                label: locale["editform.velocity"],
                items: {
                    "{value} m/s": "m/s",
                    "{value} km/h": "km/h",
                    "{value} mph": "mph",
                    "{value} kn": "knot"
                }
            },
            Volume: {
                label: locale["editform.volume"],
                items: {
                    "formatmL": "Millilitre",
                    "formatL": "Litre",
                    "formatm3": "Cubic Metre"
                }
            },
            Energy: {
                label: locale["editform.energy"],
                items: {
                    "formatW": "Watt (W)",
                    "formatKW": "Kilowatt (KW)",
                    "formatVA": "Volt-Ampere (VA)",
                    "formatKVA": "Kilovolt-Ampere (KVA)",
                    "formatVAR": "Volt-Ampere Reactive (VAR)",
                    "formatVH": "Watt-Hour (VH)",
                    "formatKWH": "Kilowatt-Hour (KWH)",
                    "formatJ": "Joule (J)",
                    "formatEV": "Electron-Volt (EV)",
                    "formatA": "Ampere (A)",
                    "formatV": "Volt (V)",
                    "{value} dBm": "Decibell-Milliwatt (DBM)"
                }
            },
            Temperature: {
                label: locale["editform.temperature"],
                items: {
                    "{value} °C": "Celsius (°C)",
                    "{value} °F": "Farenheit (°F)",
                    "{value} K": "Kelvin (K)"
                }
            },
            Pressure: {
                label: locale["editform.pressure"],
                items: {
                    "{value} mbar": "Millibars",
                    "{value} hPa": "Hectopascals",
                    "{value} &quot;Hg": "Inches of Mercury",
                    "formatpsi": "PSI"
                }
            }
        };
    }

    static get aggregatoroptions_selct2()
    {
        var result = [{id: "", text: ""}];
        for (var index in EditForm.aggregatoroptions2)
        {
            result.push({id: index, text: EditForm.aggregatoroptions2[index]});
        }
        return result;
    }
    static get aggregatoroptions2()
    {
        return {
            "avg": "avg",
            "count": "count",
            "dev": "dev",
            "ep50r3": "ep50r3",
            "ep50r7": "ep50r7",
            "ep75r3": "ep75r3",
            "ep75r7": "ep75r7",
            "ep90r3": "ep90r3",
            "ep90r7": "ep90r7",
            "ep95r3": "ep95r3",
            "ep95r7": "ep95r7",
            "ep999r3": "ep999r3",
            "ep999r7": "ep999r7",
            "ep99r3": "ep99r3",
            "ep99r7": "ep99r7",
            "first": "first",
            "last": "last",
            "max": "max",
            "mimmax": "mimmax",
            "mimmin": "mimmin",
            "min": "min",
            "mult": "mult",
            "p50": "p50",
            "p75": "p75",
            "p90": "p90",
            "p95": "p95",
            "p99": "p99",
            "p999": "p999",
            "sum": "sum",
            "zimsum": "zimsum"};
    }

    get aggregatoroptions()
    {
        return {"none": "none",
            "avg": "avg",
            "count": "count",
            "dev": "dev",
            "ep50r3": "ep50r3",
            "ep50r7": "ep50r7",
            "ep75r3": "ep75r3",
            "ep75r7": "ep75r7",
            "ep90r3": "ep90r3",
            "ep90r7": "ep90r7",
            "ep95r3": "ep95r3",
            "ep95r7": "ep95r7",
            "ep999r3": "ep999r3",
            "ep999r7": "ep999r7",
            "ep99r3": "ep99r3",
            "ep99r7": "ep99r7",
            "first": "first",
            "last": "last",
            "max": "max",
            "mimmax": "mimmax",
            "mimmin": "mimmin",
            "min": "min",
            "mult": "mult",
            "p50": "p50",
            "p75": "p75",
            "p90": "p90",
            "p95": "p95",
            "p99": "p99",
            "p999": "p999",
            "sum": "sum",
            "zimsum": "zimsum"};
    }

    get tabs()
    {
        return [{id: "general-tab", title: locale["editchartform.general"], contentid: "tab_general"},
            {id: "metrics-tab", title: locale["editchartform.metrics"], contentid: "tab_metric"},
            {id: "json-tab", title: locale["editchartform.json"], contentid: "tab_json"}
        ];
    }

    inittabcontent()
    {
        this.tabcontent = {};
        this.tabcontent.tab_general = {};
        this.tabcontent.tab_metric = {};
        this.tabcontent.tab_json = {};
        var edit_dimensions = {tag: "form", class: "form-horizontal form-label-left col-3", id: "edit_dimensions", label: {show: true, text: locale["editform.dimensions"], checker: false}};
        edit_dimensions.content = [{tag: "div", class: "form-group form-group-custom", content: [
                    {tag: "label", class: "control-label control-label-custom120", text: locale["editform.span"], lfor: "dimensions_span"},
                    {tag: "select", class: "form-control dimensions_input", prop_key: "size", id: "dimensions_span", name: "dimensions_span", key_path: 'size', default: "", options: this.spanoptions}
                ]},
            {tag: "div", class: "form-group form-group-custom", content: [
                    {tag: "label", class: "control-label control-label-custom120", text: locale["editform.height"], lfor: "dimensions_height"},
                    {tag: "input", type: "text", class: "form-control dimensions_input", prop_key: "height", id: "dimensions_height", name: "dimensions_height", key_path: 'height', default: "300px"}
                ]}
        ];
//        this.tabcontent.tab_metric.active = true;
        var current = this;
        var edit_q = {tag: "div", class: 'forms col-12', id: "edit_q"};
        var q_template = [{tag: "form", class: "form-horizontal form-label-left edit-query", id: "{index}_query", content: [
                    {tag: "div", class: "form-group form-group-custom forinside", content: [
                            {tag: "label", class: "control-label control-label-custom-legend", text: locale["editform.disabled"], lfor: "metric_check_disabled"},
                            {tag: "input", type: "checkbox", class: "js-switch-small metric_check_disabled", prop_key: "check_disabled", id: "{index}_metric_check_disabled", name: "metric_check_disabled", key_path: 'check_disabled', default: false}
                        ]},
                    {tag: "div", class: "form-group form-group-custom form-inline", content: [
                            {tag: "label", class: "control-label control-label-custom-legend", text: locale["tags"], lfor: "tags"},
                            {tag: "div", class: "data-label tags", prop_key: "tags", key_path: "info.tags", id: "{index}_tags", type: "split_string", split: ";"},
                            {tag: "label", class: "control-label query-label tags", text: '<a><i class="fa fa-plus "></i></a>'}
                        ]},
                    {tag: "div", class: "form-group form-group-custom form-inline", content: [
                            {tag: "label", class: "control-label control-label-custom-legend", text: locale["metrics"], lfor: "metrics"},
                            {tag: "div", class: "data-label metrics", prop_key: "metrics", key_path: "info.metrics", id: "{index}_metrics", type: "split_string", split: ";"},
                            {tag: "label", class: "control-label query-label metrics", text: '<a><i class="fa fa-plus "></i></a>'}
                        ]},
                    {tag: "div", class: "form-group form-group-custom form-inline", content: [
                            {tag: "label", class: "control-label control-label-custom-legend", text: locale["editform.aggregator"], lfor: "aggregator"},
                            {tag: "select", class: "form-control query_input aggregator", prop_key: "aggregator", id: "{index}_aggregator", name: "aggregator", key_path: 'info.aggregator', default: "", options: this.aggregatoroptions},
                            {tag: "label", class: "control-label control-label-custom-legend", text: locale["editform.alias"], lfor: "alias", info: {text: locale["editform.alias.text"]}},
                            {tag: "input", type: "text", class: "form-control query_input alias", prop_key: "alias", id: "{index}_alias", name: "alias", key_path: 'info.alias', default: ""},
                            {tag: "label", class: "control-label control-label-custom155", text: locale["editform.aliasSecondary"], lfor: "alias2", info: {text: locale["editform.aliasSecondary.text"]}},
                            {tag: "input", type: "text", class: "form-control query_input alias2", prop_key: "alias2", id: "{index}_alias2", name: "alias2", key_path: 'info.alias2', default: ""}
                        ]},
                    {tag: "div", class: "form-group form-group-custom form-inline", content: [
                            {tag: "label", class: "control-label control-label-custom-legend", text: locale["editform.downSample"], lfor: "down-sample"},
                            {tag: "input", type: "text", class: "form-control query_input down-sample-time", prop_key: "time", id: "{index}_down-sample-time", name: "down-sample-time", key_path: 'info.ds.time', default: ""},
                            {tag: "label", class: "control-label control-label-custom-legend", text: locale["editform.aggregator"], lfor: "down-sample-aggregator"},
                            {tag: "select", class: "form-control query_input down-sample-aggregator", prop_key: "aggregator", id: "{index}_down-sample-aggregator", name: "down-sample-aggregator", key_path: 'info.ds.aggregator', default: "", options: EditForm.aggregatoroptions2},
                            {tag: "label", class: "control-label control-label-custom155", text: locale["editform.disableDownsampling"], lfor: "disable_downsampling"},
                            {tag: "input", type: "checkbox", class: "js-switch-small disable_downsampling", prop_key: "downsamplingstate", id: "{index}_disable_downsampling", name: "disable_downsampling", key_path: 'info.downsamplingstate', default: false}
                        ]},
                    {tag: "div", class: "form-group form-group-custom", content: [
                            {tag: "label", class: "control-label control-label-custom-legend", text: locale["editform.rate"], lfor: "alias2"},
                            {tag: "input", type: "checkbox", class: "js-switch-small enable_rate", prop_key: "rate", id: "{index}_enable_rate", name: "enable_rate", key_path: 'info.rate', default: false}
                        ]},
                    {tag: "div", class: "btn btn-outline-success dublicateq btn-sm m-1", id: "{index}_dublicateq",
                        text: locale["editchartform.dublicate"],
                        actions: {click: function () {
                                var curindex = parseInt($(this).attr('template_index'));
                                var qitem = clone_obg(current.dashJSON.rows[current.row]["widgets"][current.index].q[curindex]);
                                current.dashJSON.rows[current.row]["widgets"][current.index].q.splice(curindex, 0, qitem);
                                var contener = $(this).parent().parent();
                                current.repaintq(contener, edit_q.content);
//                                contener.html("");
//                                current.drawcontent(edit_q.content, contener, current.dashJSON.rows[current.row]["widgets"][current.index]);
                                current.change($(this));
                            }
                        }
                    },
                    {tag: "div", class: "btn btn-outline-danger removeq btn-sm m-1", id: "{index}_removeq",
                        text: locale["editchartform.remove"],
                        actions: {click: function () {
                                var curindex = parseInt($(this).attr('template_index'));
                                current.dashJSON.rows[current.row]["widgets"][current.index].q.splice(curindex, 1);
//                                console.log(current.dashJSON.rows[current.row]["widgets"][current.index].q);
                                var contener = $(this).parent().parent();
//                                contener.html("");
//                                current.drawcontent(edit_q.content, contener, current.dashJSON.rows[current.row]["widgets"][current.index]);
                                current.repaintq(contener, edit_q.content);
                                current.change($(this));
                            }
                        }
                    }
                ]}
        ];
         edit_q.content = [{tag: "button", class: "btn btn-outline-success Addq btn-sm m-1",
                text: locale["editchartform.add"],
                id: "addq",
                key_path: "q",
                check_dublicates: this.check_q_dublicates,
                template: q_template,
                actions: {click: function () {
                        if (!current.dashJSON.rows[current.row]["widgets"][current.index].q)
                        {
                            current.dashJSON.rows[current.row]["widgets"][current.index].q = [];
                        }
                        current.dashJSON.rows[current.row]["widgets"][current.index].q.push({});
                        var qindex = current.dashJSON.rows[current.row]["widgets"][current.index].q.length - 1;
                        var contener = $(this).parent();

//                        contener.html("");
//                        current.drawcontent(edit_q.content, contener, current.dashJSON.rows[current.row]["widgets"][current.index]);
                        current.repaintq(contener, edit_q.content);

                    }
                }
            }
        ];
        this.tabcontent.tab_general.forms = [edit_dimensions];
        this.tabcontent.tab_metric.forms = [edit_q];

        this.tabcontent.tab_time = {};
        var edit_time = {tag: "form", class: 'form-inline form-label-left edit-times col', id: "edit_time"};
        edit_time.content = [{tag: "div", class: "filter form-row", content: [
                    {tag: "div", class: "form-inline col-6", content: [
                      {tag: "div", class: "form-inline col-12", content: [
                            {tag: "label", class: "control-label", text: [locale["editform.times"], "_x0"], lfor: "padding_height"},
                            {tag: "span", class: "float-right q_warning",info: {text: locale["editform.infoShift.text"]} },
                            {tag: "div", id: "reportrange_private", class: "form-control form-control dropdown-toggle", style: "background: #fff; cursor: pointer; padding: 5px 10px; border: 1px solid #ccc",
                                content: [
                                    {tag: "i", class: "fa fa-calendar"},
                                    {tag: "span"}
                                ]},

                            {tag: "select", id: "shiftX", class: "form-control form-control-sm", name: "shifttime", key_path: "times.shift", default: "off", options: this.shifttimes}
                        ]},
                    {tag: "div", class: "form-inline col-12", content: [
                            {tag: "label", class: "control-label", text: [locale["editform.times"], "_x1"], lfor: "padding_height"},
                            {tag: "span", class: "float-right q_warning",info: {text: locale["editform.infoShift.text"]} },
                            {tag: "div", id: "reportrange_privateX1", class: "form-control form-control dropdown-toggle", style: "background: #fff; cursor: pointer; padding: 5px 10px; border: 1px solid #ccc",content: [
                                    {tag: "i", class: "fa fa-calendar"},
                                    {tag: "span"}
                                ]},
                            {tag: "select", id: "shiftX1", class: "form-control form-control-sm", name: "shifttime", key_path: "times.shift", default: "off", options: this.shifttimes}
                        ]}                    
                    ]},
                    {tag: "div", class: "col-6", content: [
                       {tag: "div", class: "form-inline col-12", id: "refresh_wrap_private", content: [
                            {tag: "label", class: "control-label", text: [locale["dashboard.title.refresh"]], lfor: "padding_height"},
                            {tag: "select", id: "refreshtime_private", class: "form-control form-control-sm", name: "refreshtime", key_path: 'times.intervall', options: this.privaterefreshtimes}
                        ]}     
                    ]}                                                         
                ]}             
        ];

        this.tabcontent.tab_time.forms = [edit_time];
        this.tabcontent.tab_json = {};
        var edit_json = {tag: "form", class: 'edit-ljson col', id: "edit_json", label: {show: true, text: locale["editform.jsonEditor"], checker: false}};

        edit_json.content = [{tag: "div", id: "jsoneditor"},
            {tag: "div", class: "col-md-12 col-sm-12 col-xs-12 text-right", content: [
                    {tag: "button", class: "btn btn-outline-primary m-1", type: "button", value: "Default", id: "jsonReset", text: locale["reset"], actions: {click: function () {
                                var jsonstr = JSON.stringify(current.dashJSON.rows[current.row]["widgets"][current.index], jsonmaker);
                                current.editor.set(JSON.parse(jsonstr));
                            }}},
                    {tag: "button", class: "btn btn-outline-primary m-1", type: "button", value: "Default", id: "jsonApply", text: locale["apply"], actions: {click: function () {
                                var tmpJson = current.editor.get();
                                clearTimeout(current.dashJSON.rows[current.row]["widgets"][current.index].timer);
                                for (var key in tmpJson)
                                {
                                    current.dashJSON.rows[current.row]["widgets"][current.index][key] = clone_obg(tmpJson[key]);
                                }

                                for (var key in current.dashJSON.rows[current.row]["widgets"][current.index])
                                {
                                    if (!tmpJson[key])
                                    {
                                        delete current.dashJSON.rows[current.row]["widgets"][current.index][key];
                                    }

                                }
                                current.dashJSON.rows[current.row]["widgets"][current.index].manual = true;
                                var check = document.getElementById('manual');
                                if (!check.checked)
                                {
                                    current.formwraper.find('#manual').attr("checked", true).trigger('click');
                                } else
                                {
                                    current.change($(this));
                                }

                            }}}
                ]
            }];
//        this.tabcontent.tab_json.active = true;

        this.tabcontent.tab_json.forms = [edit_json];
    }

    repaintq(contener, content)
    {

        contener.empty();
        this.drawcontent(content, contener, this.dashJSON.rows[this.row]["widgets"][this.index]);
        this.formwraper.find("input.flat").iCheck({checkboxClass: icheckbox_flat_clr, radioClass: iradio_flat_clr});
        this.formwraper.find("select").select2({minimumResultsForSearch: 15});
    }

    static get refreshtimes() {
        return {
            "off": "Refresh Off",
            " 5000": "Refresh every 5s", 
            " 10000": "Refresh every 10s",
            " 30000": "Refresh every 30s",
            " 60000": "Refresh every 1m",
            " 300000": "Refresh every 5m",
            " 900000": "Refresh every 15m",
            " 1800000": "Refresh every 30m",
            " 3600000": "Refresh every 1h",
            " 7200000": "Refresh every 2h",
            " 86400000": "Refresh every 1d"
        };
    }

    get privaterefreshtimes() {
        return {
            "General": locale["editform.refreshGeneral"],
            "off": locale["editform.refreshOff"],
            " 5000": locale["editform.refresh5s"],
            " 10000": locale["editform.refresh10s"],
            " 30000": locale["editform.refresh30s"],
            " 60000": locale["editform.refresh1m"],
            " 300000": locale["editform.refresh5m"],
            " 900000": locale["editform.refresh15m"],
            " 1800000": locale["editform.refresh30m"],
            " 3600000": locale["editform.refresh1h"],
            " 7200000": locale["editform.refresh2h"],
            " 86400000": locale["editform.refresh1d"]
        };
    }
    get shifttimes() {
        return {
            "off": "Shift Time",
            " 300000": "shift 5m",
            " 900000": "shift 15m",
            " 1800000": "shift 30m",
            " 3600000": "shift 1h",
            " 10800000": "shift 3h",
            " 21600000": "shift 6h",
            " 43200000": "shift 12h",
            " 86400000": "shift 1d",
            " 259200000": "shift 3d",
            " 604800000 ": "shift 7d",
            " 2592000000 ": "shift 30d"
        };
    }
    check_q_dublicates(contener, json) {

        var cache = {};
        var colorindex = 0;
        for (var dub_index in json)
        {
            var tags = [];
            if ((typeof (json[dub_index])) === "string")
            {
                var query = "?" + json[dub_index];
                tags = getParameterByName("tags", query).split(";");
            } else
            {
                if (json[dub_index].info)
                {
                    if (json[dub_index].info.tags)
                    {
                        tags = json[dub_index].info.tags.split(";");
                    }

                }

            }

            tags.sort();
            var s_tags = tags.toString();
            if (!cache[s_tags])
            {
                cache[s_tags] = [];
            }
            cache[s_tags].push(dub_index);
            var items = cache[s_tags];
            colorindex = Object.keys(cache).indexOf(s_tags) % colorPalette.length;
            contener.find("form#" + dub_index + "_query").attr("colorindex", colorindex);
            $("[colorindex='" + colorindex + "']").css("border-color", colorPalette[colorindex]);
            $("[colorindex='" + colorindex + "']").attr("count", items.length);
        }

        contener.find(".edit-query[count!=1]").each(function () {
            if (!$(this).find('.fa').hasClass('q_warning'))
            {
                var worn = $('<i class="fa fas fa-info-circle q_warning"  aria-hidden="true"  data-toggle="tooltip" data-placement="left" title= "' + locale["editform.title.mergeSimilarQueries"] + '" ></i>');
                worn.appendTo($(this));
//                worn.tooltip();
            }
        }
        );
        contener.find(".edit-query[count=1] .q_warning[data-toggle='tooltip']").remove();
    }

    gettabcontent(key)
    {
        if (key === null)
        {
            return this.tabcontent;
        }
        return this.tabcontent[key];
    }

    jspluginsinit() {
        var form = this;
        this.formwraper.find("select").select2({minimumResultsForSearch: 15});
        this.formwraper.find("input.flat").iCheck({checkboxClass: icheckbox_flat_clr, radioClass: iradio_flat_clr});

        this.formwraper.find('[data-toggle="tooltip"]').tooltip();
        this.formwraper.find('.cl_picer_input').colorpicker({format: 'rgba'}).on('hidePicker', function () {
            form.change($(this).find("input"));
        });

        var current = this;
        this.formwraper.find('[data-toggle="tab"]').on('shown.bs.tab', function (e) {
            if (e.delegateTarget.hash === "#tab_json")
            {
                var jsonstr = JSON.stringify(current.dashJSON.rows[form.row].widgets[form.index], jsonmaker);
                current.editor.set(JSON.parse(jsonstr));
            }
        });

        this.formwraper.on("blur", "input", function () {
            if (!$(this).parent().hasClass("edit"))
            {
                if (!$(this).hasClass("ace_search_field"))
                {
                    form.change($(this));
                }
            }
        });

        this.formwraper.on("change", "select", function () {
            form.change($(this));
        });

        var options = {modes: ['form', 'tree', 'code'], mode: 'code'};
        this.editor = new JSONEditor(document.getElementById("jsoneditor"), options);

        var jsonstr = JSON.stringify(form.dashJSON.rows[form.row]["widgets"][form.index], jsonmaker);
        this.editor.set(JSON.parse(jsonstr));

        this.formwraper.find('.cl_picer_noinput').colorpicker({format: 'rgba'}).on('hidePicker', function () {
            form.change($(this).find("input"));
        });

        if (form.dashJSON.rows[form.row]["widgets"][form.index].times)
        {

            if (form.dashJSON.rows[form.row]["widgets"][form.index].times.intervall)
            {
                $("#refreshtime_private").val(form.dashJSON.rows[form.row]["widgets"][form.index].times.intervall);               
            }

            if (form.dashJSON.rows[form.row]["widgets"][form.index].times.pickerlabel)
            {
                if (form.dashJSON.rows[form.row]["widgets"][form.index].times.pickerlabel !== DtPicerlocale["customRangeLabel"])
                {
                    PicerOptionSet2.startDate = PicerOptionSet2.ranges[form.dashJSON.rows[form.row]["widgets"][form.index].times.pickerlabel][0];
                    PicerOptionSet2.endDate = PicerOptionSet2.ranges[form.dashJSON.rows[form.row]["widgets"][form.index].times.pickerlabel][1];
                    $('#reportrange_private span').html(form.dashJSON.rows[form.row]["widgets"][form.index].times.pickerlabel);                   
//                    $('#reportrange_privateX1 span').html(form.dashJSON.rows[form.row]["widgets"][form.index].times.pickerlabel);                   
                                        
                } else
                {
                    PicerOptionSet2.startDate = moment(form.dashJSON.rows[form.row]["widgets"][form.index].times.pickerstart);
                    PicerOptionSet2.endDate = moment(form.dashJSON.rows[form.row]["widgets"][form.index].times.pickerend);
                    $('#reportrange_private span').html(PicerOptionSet2.startDate.format("MM/DD/YYYY HH:mm:ss") + " - " + PicerOptionSet2.endDate.format("MM/DD/YYYY HH:mm:ss"));                    
//                    $('#reportrange_privateX1 span').html(PicerOptionSet2.startDate.format("MM/DD/YYYY HH:mm:ss") + " - " + PicerOptionSet2.endDate.format("MM/DD/YYYY HH:mm:ss"));                    
                }
            }
        }
        PicerOptionSet2.minDate = getmindate();
        $('#reportrange_private').daterangepicker(PicerOptionSet2, cbJson(form.dashJSON.rows[form.row]["widgets"][form.index], $('#reportrange_private')));
//        $('#reportrange_privateX1').daterangepicker(PicerOptionSet2, cbJson(form.dashJSON.rows[form.row]["widgets"][form.index], $('#reportrange_privateX1')));
        $('#reportrange_private').on('apply.daterangepicker', function (ev, picker) {
            var input = $('#reportrange_private');
            form.change(input);
        });
//        $('#reportrange_privateX1').on('apply.daterangepicker', function (ev, picker) {
//            var inputX1 = $('#reportrange_privateX1');
//            form.change(inputX1);
//        });
        
//      shiftX1  =========================================================
            if (form.dashJSON.rows[form.row]["widgets"][form.index].times)
            {
                if (form.dashJSON.rows[form.row]["widgets"][form.index].times.pickerlabel)
                {
                    if (form.dashJSON.rows[form.row]["widgets"][form.index].times.pickerlabel !== DtPicerlocale["customRangeLabel"])
                    {
                        PicerOptionSet2.startDate = PicerOptionSet2.ranges[form.dashJSON.rows[form.row]["widgets"][form.index].times.pickerlabel][0];
                        PicerOptionSet2.endDate = PicerOptionSet2.ranges[form.dashJSON.rows[form.row]["widgets"][form.index].times.pickerlabel][1];

                        $('#reportrange_privateX1 span').html(form.dashJSON.rows[form.row]["widgets"][form.index].times.pickerlabel);

                    } else
                    {
                        PicerOptionSet2.startDate = moment(form.dashJSON.rows[form.row]["widgets"][form.index].times.pickerstart);
                        PicerOptionSet2.endDate = moment(form.dashJSON.rows[form.row]["widgets"][form.index].times.pickerend);

                        $('#reportrange_privateX1 span').html(PicerOptionSet2.startDate.format("MM/DD/YYYY HH:mm:ss") + " - " + PicerOptionSet2.endDate.format("MM/DD/YYYY HH:mm:ss"));
                    }
                }
            }
            PicerOptionSet2.minDate = getmindate();

            $('#reportrange_privateX1').daterangepicker(PicerOptionSet2, cbJson(form.dashJSON.rows[form.row]["widgets"][form.index], $('#reportrange_privateX1')));

            $('#reportrange_privateX1').on('apply.daterangepicker', function (ev, picker) {
                var inputX1 = $('#reportrange_privateX1');
                form.change(inputX1);
            });
        
//     /shiftX1  =========================================================

        this.formwraper.on("click", "span.tag_label .fa-times", function () {
            var input = $(this).parents(".data-label");
            $(this).parents(".tag_label").remove();
            form.change(input);
            var contener = $('.edit-form #tabpanel #TabContent #tab_metric div #edit_q .form_main_block');
            var json = form.dashJSON.rows[form.row]["widgets"][form.index].q;
            form.check_q_dublicates(contener, json);
        });

        this.formwraper.on("click", ".query-label .fa-plus", function () {
            var input = $(this).parents(".form-group").find(".data-label");
            if (input.hasClass("metrics"))
            {
                input.append("<span class='control-label metrics tag_label'><span class='tagspan'><span class='text'></span><a><i class='fa fas fa-pencil-alt'></i> </a> <a><i class='fa fas fa-times'></i></a></span></span>");
                input.find(".tagspan").last().hide();
                input.find(".tagspan").last().after('<div class="edit"><input id="metrics" name="metrics" class="form-control query_input" type="text" value=""><a class="mx-1"><i class="fa fa-check"></i></a><a class="mr-1"><i class="fa fas fa-times"></i></a></div>');
                var metricinput = input.find("input");
                form.makeMetricInput(metricinput, input);
            }

            if (input.hasClass("tags"))
            {
                input.append("<span class='control-label tags tag_label' ><span class='tagspan'><span class='text'></span><a><i class='fa fas fa-pencil-alt'></i> </a> <a><i class='fa fas fa-times'></i></a></span></span>");
                input.find(".tagspan").last().hide();
                input.find(".tagspan").last().after('<div class="edit"><input id="tagk" name="tagk" class="form-control query_input" type="text" value=""> </div><div class="edit"><input id="tagv" name="tagv" class="form-control query_input" type="text" value=""> <a class="mr-1"><i class="fa fa-check"></i></a><a class="mr-1"><i class="fa fas fa-times"></i></a></div>');
                var tagkinput = input.find("input#tagk");
                form.maketagKInput(tagkinput, input);
            }
        });

        this.formwraper.on("click", "span.tag_label .fa-check", function () {
            var input = $(this).parents(".form-group").find(".data-label");
            if (input.hasClass("metrics"))
            {
                var metricinput = input.find("input");
                if (metricinput.val() === "")
                {
                    metricinput.parents(".tag_label").remove();
                } else
                {
                    metricinput.parents(".tag_label").find(".text").html(metricinput.val());
                    metricinput.parents(".tag_label").find(".tagspan").show();
                    metricinput.parent().remove();
                }
            }
            if (input.hasClass("tags"))
            {

                var keyinput = input.find("#tagk");
                var valinput = input.find("#tagv");
                if (keyinput.val() === "")
                {
                    keyinput.parents(".tag_label").remove();
                } else
                {
                    if (valinput.val() === "")
                    {
                        valinput.val("*");
                    }
                    keyinput.parents(".tag_label").find(".text").html(keyinput.val() + "=" + valinput.val());
                    keyinput.parents(".tag_label").find(".tagspan").show();
                    keyinput.parent().remove();
                    valinput.parent().remove();
                }
            }
            form.change(input);
            var contener = $('.edit-form #tabpanel #TabContent #tab_metric div #edit_q .form_main_block');
            var json = form.dashJSON.rows[form.row]["widgets"][form.index].q;
            form.check_q_dublicates(contener, json);
        });

        this.formwraper.on("click", "span.tagspan .fa-pencil-alt", function () {
            $(this).parents(".tagspan").hide();
            var input = $(this).parents(".form-group").find(".data-label");
            if ($(this).parents(".tag_label").hasClass("metrics"))
            {

                $(this).parents(".tagspan").after('<div class="edit"><input id="metrics" name="metrics" class="form-control query_input" type="text" value="' + $(this).parents(".tagspan").find(".text").html() + '"><a><i class="fa fa-check"></i></a><a><i class="fa fas fa-times"></i></a></div>');
                var metricinput = $(this).parents(".tag_label").find("input");
                form.makeMetricInput(metricinput, input);
            }

            if ($(this).parents(".tag_label").hasClass("tags"))
            {
                var tag_arr = $(this).parents(".tagspan").find(".text").html().split("=");
                $(this).parents(".tagspan").after('<div class="edit"><input id="tagk" name="tagk" class="form-control query_input" type="text" value="' + tag_arr[0] + '"> </div><div class="edit"><input id="tagv" name="tagv" class="form-control query_input" type="text" value="' + tag_arr[1] + '"> <a><i class="fa fa-check"></i></a><a><i class="fa fas fa-times"></i></a></div>');
                var tagkinput = $(this).parents(".tag_label").find("input#tagk");
                form.maketagKInput(tagkinput, input);
            }
        });

    }

    resetjson()
    {

    }

    applyjson()
    {

    }

    change(input) {
        var value = null;
//        console.log(input);
        if (input.attr('type') === 'checkbox')
        {
            var elem = document.getElementById(input.attr("id"));
            value = elem.checked;
        }
        if (input.attr('type') === 'choose_array')
        {
            value = [];
            input.find('[type=checkbox]:checked').each(function () {
                value.push(Number($(this).attr('index')));
            });
            input.find('[type=radio]:checked').each(function () {
                value.push(Number($(this).attr('index')));
            });
        }


        if (input.attr('type') === 'text')
        {
            value = input.val();
        }

        if (input.attr('type') === 'number')
        {
            if (input.val().trim() === "")
            {
                value = "";
            } else
            {
                value = Number(input.val());

                if (input.attr('max'))
                {
                    var max = Number(input.attr('max'));
                    value = Math.min(value, max);
                    input.val(value);
                }
                if (input.attr('min'))
                {
                    var min = Number(input.attr('min'));
                    value = Math.max(value, min);
                    input.val(value);
                }
            }


        }
        if (input.prop("tagName"))
        {
            if (input.prop("tagName").toLowerCase() === "select")
            {
                value = input.val();
            }
        }

        if (input.attr('type') === 'split_string')
        {
            value = "";
            input.find('.text').each(function () {
                value = value + $(this).text() + ";";
            });
        }


        var parent;
        var tmpindex = input.attr('template_index');
        if (tmpindex)
        {
            parent = input.parents(".form_main_block").attr('key_path');
        }

        this.setvaluebypath(input.attr('key_path'), value, tmpindex, parent);
        if ($('[key_path="' + input.attr('key_path') + '"]').length > 1)
        {
            if (input.parent().hasClass("cl_picer") && !input.parent().hasClass("hasdublicatepath"))
            {
                $('[key_path="' + input.attr('key_path') + '"]').parent().colorpicker('setValue', value);
            }
        }

        showsingleWidget(this.row, this.index, this.dashJSON, false, false, false, function () {
//            var jsonstr = JSON.stringify(opt, jsonmaker);
//            editor.set(JSON.parse(jsonstr));
        });
        if (this.aftermodifier)
        {
            this.aftermodifier();
        }
    }
    getdefvalue(path)
    {

        if (path === null)
        {
            return this.deflist;
        }
        return this.deflist[path];
    }
    setvaluebypath(path, value, tmpindex, parent)
    {
        if (value === null)
        {
            return;
        }
        if (typeof (value) === "string")
        {
            value = value.trim();
        }
        var a_path = path.split('.');
        var object = this.dashJSON.rows[this.row]["widgets"][this.index];

        if (parent)
        {
            var a_parent = parent.split('.');
            for (var key in a_parent)
            {
                object = object[a_parent[key]];
            }
            object = object[tmpindex];
        }

        for (var key in a_path)
        {
            if (key == (a_path.length - 1))
            {
                if (this.getdefvalue(path) === value)
                {
                    delete object[a_path[key]];
                } else
                {
                    object[a_path[key]] = value;
                }
                if (value === "")
                {
                    delete object[a_path[key]];
                }
                if ($.isArray(value))
                {
                    if (value.length === 0)
                    {
                        delete object[a_path[key]];
                    }
                }
            } else
            {
                if (!object[a_path[key]])
                {
                    object[a_path[key]] = {};
                }
            }

            object = object[a_path[key]];
        }

    }

    getvaluebypath(path, def, val)
    {
        var object;
        if (val)
        {
            object = val;
        } else
        {
            object = this.dashJSON.rows[this.row]["widgets"][this.index];
        }
        var a_path = path.split('.');
//        console.log(val);
        for (var key in a_path)
        {
            object = object[a_path[key]];
            if (typeof (object) === "undefined")
            {
                return def;
            }
        }

        return object;
    }

    makeMetricInput(metricinput, wraper, metricFilter)
    {
        var tags = "";
        wraper.parents("form").find(".tagspan .text").each(function () {
            tags = tags + $(this).text().replace("*", "(.*)") + ";";
        });

        var uri = cp + "/getfiltredmetricsnames?tags=" + tags + "&filter=" + encodeURIComponent("^(.*)$");
        $.getJSON(uri, null, function (data) {
            metricinput.autocomplete({
                lookup: data.data,
                minChars: 0
            });
        });
    }

    maketagKInput(tagkinput, wraper) {
        var uri = cp + "/gettagkey?filter=" + encodeURIComponent("^(.*)$");
        $.getJSON(uri, null, function (data) {

            var tagvinput = tagkinput.parent().next().find("#tagv");

            if (tagkinput.val() !== "")
            {
                var uri = cp + "/gettagvalue?key=" + tagkinput.val();
                $.getJSON(uri, null, function (data) {
                    tagvinput.autocomplete({
                        lookup: Object.keys(data.data),
                        minChars: 0
                    });
                });
            }
            tagkinput.autocomplete({
                lookup: data.data,
                minChars: 0,
                onSelect: function (suggestion) {
                    var uri = cp + "/gettagvalue?key=" + suggestion.value;
                    $.getJSON(uri, null, function (data) {
                        tagvinput.autocomplete({
                            lookup: Object.keys(data.data),
                            minChars: 0
                        });
                    });

                }
            });
        });
    }

}
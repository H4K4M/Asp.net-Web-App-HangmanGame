using System;
using System.Collections.Generic;
using System.Linq;
using System.Media;
using System.Reflection.Emit;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using System.Xml.Linq;
using System.Xml.XPath;
//Hakam Chedo 152120181096
namespace HW2
{
    public partial class HW2 : System.Web.UI.Page
    {
        static List<string> hints = new List<string>(); //hint list index corespond to word list box
        static string word; //random word
        static int lostCount = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                ValidationSettings.UnobtrusiveValidationMode = UnobtrusiveValidationMode.None;
                UpdatePanel.UpdateMode = UpdatePanelUpdateMode.Conditional;
                UpdatePanel.Update();
                UpdatePanel1.UpdateMode = UpdatePanelUpdateMode.Conditional;
                UpdatePanel1.Update();
                UpdatePanel2.UpdateMode = UpdatePanelUpdateMode.Conditional;
                UpdatePanel2.Update();
                GetListword();
            }
            else
            {
                if(WordLsB.SelectedItem != null)
                {
                    DeleteWordBTN.CssClass = "btn btn-danger";
                }
            }
        }
        #region Home page
        protected void GetListword()
        {
            try
            {
                //Clear word listbox and hintlist
                WordLsB.Items.Clear();
                hints.Clear();
                //Get Xml file
                XDocument doc = XDocument.Load(Server.MapPath("WordList.xml"));
                IEnumerable<XElement> words = doc.Root.Elements("word");
                // Get the words from the XML file
                foreach (XElement wordNode in words)
                {
                    WordLsB.Items.Add((string)wordNode.Element("term"));
                    hints.Add((string)wordNode.Element("hint"));
                }

                // Bind the words to a ListBox control

                WordLsB.DataBind();
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('" + ex.Message + "');</script>");
            }
        }
        //Get random word
        protected void getWord()
        {
            try
            {
                Random random = new Random();
                int index = random.Next(WordLsB.Items.Count);
                WordLsB.SelectedIndex = index;
                word = WordLsB.SelectedValue;
                hintLbl.Text = "Hint: " + hints[index];

                // mask up _ to the word
                MaskWord.Text = string.Join("", word.Select(c => c == ' ' ? ' ' : '_'));
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('" + ex.Message + "');</script>");
            }
        }
        protected void StartBTN_Click(object sender, EventArgs e)
        {
            Multiview.ActiveViewIndex = (Multiview.ActiveViewIndex + 2);
            NewGame();
        }

        protected void AddWordBTN_Click(object sender, EventArgs e)
        {
            Multiview.ActiveViewIndex = (Multiview.ActiveViewIndex + 1);
        }

        #endregion
        #region Words operation page
        protected void WordLsB_SelectedIndexChanged(object sender, EventArgs e)
        {
            SelectedwordTb.Text = WordLsB.SelectedItem.ToString() + " :"+hints[WordLsB.SelectedIndex];
        }

        protected void BackBTN_Click(object sender, EventArgs e)
        {
            Multiview.ActiveViewIndex = (Multiview.ActiveViewIndex - 1);
        }

        protected void AddBTN_Click(object sender, EventArgs e)
        {
            try
            {
                string term = AddWordTb.Text;
                string hint = HintTb.Text;

                // Load the XML file
                XmlDocument doc = new XmlDocument();
                doc.Load(Server.MapPath("WordList.xml"));

                // Check if the word already exists in the file
                XmlNode existingWord = doc.SelectSingleNode($"//word[term='{term}']");
                if (existingWord != null)
                {
                    string errorMessage = "The word " + term + " already exists in the word list";
                    //Response.Write($"<script>alert('{errorMessage}');</script>");
                    AlertPanel.Visible = true;
                    AlertPanel.CssClass = "alert alert-dismissible alert-danger";
                    Statuslbl.Text = "The word " + term + " already exists in the word list";
                }
                else
                {
                    // The word does not exist, create a new word element and add to the XML document
                    XmlElement word = doc.CreateElement("word");
                    XmlElement termElement = doc.CreateElement("term");
                    termElement.InnerText = term;
                    XmlElement hintElement = doc.CreateElement("hint");
                    hintElement.InnerText = hint;
                    word.AppendChild(termElement);
                    word.AppendChild(hintElement);
                    doc.DocumentElement.AppendChild(word);
                    doc.Save(Server.MapPath("WordList.xml"));
                    AlertPanel.Visible = true;
                    Statuslbl.Text = "The word " + term + " is added to the word list successfully";
                    //update listbox
                    GetListword();
                    //clear textboxs
                    AddWordTb.Text = "";
                    HintTb.Text = "";
                }
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('" + ex.Message + "');</script>");
            }
        }

        protected void DeleteWordBTN_Click(object sender, EventArgs e)
        {
            try
            {
                string selectedWord = WordLsB.SelectedItem.ToString();
                // Load the XML file
                XmlDocument doc = new XmlDocument();
                doc.Load(Server.MapPath("WordList.xml"));
                XmlNode existingWord = doc.SelectSingleNode($"//word[term='{selectedWord}']");
                doc.DocumentElement.RemoveChild(existingWord);
                doc.Save(Server.MapPath("WordList.xml"));

                SelectedwordTb.Text = "";
                GetListword();
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('" + ex.Message + "');</script>");
            }
        }
        #endregion
        #region Game page
        protected void Timer_Tick(object sender, EventArgs e)
        {
            try
            {
                int remainingTime = int.Parse(Timerlbl.Text);
                remainingTime--;

                if (remainingTime >= 0)
                {
                    Timerlbl.Text = remainingTime.ToString();
                }
                //time's up
                else
                {
                    gameOver();
                }
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('" + ex.Message + "');</script>");
            }
        }
        protected void gameOver()
        {
            try
            {
                HangMan.Visible = true; //show hangman image when time'up or lost count reach to 8
                HangMan.ImageUrl = "~/images/08.png";
                Timer.Enabled = false;  //stop timer
                MaskWord.Font.Size = 36;
                MaskWord.Text = "Try next time <br> The word is " + word;
                SoundPlayer playSound = new SoundPlayer(MapPath("~/sounds/GameOver.wav"));
                playSound.Play();
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('" + ex.Message + "');</script>");
            }
        }
        protected void gameWin()
        {
            try
            {
                SoundPlayer playSound = new SoundPlayer(MapPath("~/sounds/GameWin.wav"));
                playSound.Play();
                lostCount = 8;  //avoid user press any letter button and make game bugs after win
                Timer.Enabled = false;
                HangMan.Visible = true;
                HangMan.ImageUrl = "~/images/Win.png";
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('" + ex.Message + "');</script>");
            }
        }
        protected void CheckLetter(char letter)
        {
            try
            {
                if (word.Contains(letter) && MaskWord.Text.Contains('_'))
                {
                    int index = word.IndexOf(letter);
                    while (index != -1)
                    {
                        MaskWord.Text = MaskWord.Text.Substring(0,index ) + letter + MaskWord.Text.Substring(index + 1);
                        index = word.IndexOf(letter, index + 1);    //check is the word contains another same letter
                        if (!MaskWord.Text.Contains('_')) { gameWin(); }
                    }    
                }
                else
                {
                    lostCount++;
                    if(lostCount == 1) 
                    {
                        HangMan.Visible = true; //show hangman after user click wrong answer
                        HangMan.ImageUrl = "~/images/01.png";
                    }
                    else if(lostCount == 2) {
                        HangMan.ImageUrl = "~/images/02.png";
                    }
                    else if(lostCount == 3) {
                        HangMan.ImageUrl = "~/images/03.png";
                    }
                    else if(lostCount == 4) {
                        HangMan.ImageUrl = "~/images/04.png";
                    }
                    else if(lostCount == 5) {
                        HangMan.ImageUrl = "~/images/05.png";
                    }
                    else if(lostCount == 6) {
                        HangMan.ImageUrl = "~/images/06.png";
                    }
                    else if(lostCount == 7) {
                        HangMan.ImageUrl = "~/images/07.png";
                    }
                    else if(lostCount == 8) {
                        HangMan.ImageUrl = "~/images/08.png";
                        gameOver();
                    }
                }
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('" + ex.Message + "');</script>");
            }
        }
        protected void Letter_Click(object sender, EventArgs e)
        {
            try
            {
                SoundPlayer playSound = new SoundPlayer(MapPath("~/sounds/Click.wav"));
                playSound.Play();
                if (sender == Abtn)
                {
                    CheckLetter('a');
                    Abtn.CssClass = "btn btn-warning disabled"; 
                }
                else if (sender == Bbtn)
                {
                    CheckLetter('b');
                    Bbtn.CssClass = "btn btn-warning disabled";
                }
                else if (sender == Cbtn)
                {
                    CheckLetter('c');
                    Cbtn.CssClass = "btn btn-warning disabled"; 
                }
                else if (sender == Çbtn)
                {
                    CheckLetter('ç');
                    Çbtn.CssClass = "btn btn-warning disabled"; 
                }
                else if (sender == Dbtn)
                {
                    CheckLetter('d');
                    Dbtn.CssClass = "btn btn-warning disabled";
                }
                else if (sender == Ebtn)
                {
                    CheckLetter('e'); 
                    Ebtn.CssClass = "btn btn-warning disabled"; 
                }
                else if (sender == Fbtn)
                {
                    CheckLetter('f'); 
                    Fbtn.CssClass = "btn btn-warning disabled"; 
                }
                else if (sender == Gbtn)
                {
                    CheckLetter('g');
                    Gbtn.CssClass = "btn btn-warning disabled"; 
                }
                else if (sender == Ğbtn)
                {
                    CheckLetter('ğ');
                    Ğbtn.CssClass = "btn btn-warning disabled"; 
                }
                else if (sender == Hbtn)
                {
                    CheckLetter('h');
                    Hbtn.CssClass = "btn btn-warning disabled"; 
                }
                else if (sender == Ibtn)
                {
                    CheckLetter('ı');
                    Ibtn.CssClass = "btn btn-warning disabled"; 
                }
                else if (sender == İbtn)
                {
                    CheckLetter('i');
                    İbtn.CssClass = "btn btn-warning disabled"; 
                }
                else if (sender == Jbtn)
                {
                    CheckLetter('j'); 
                    Jbtn.CssClass = "btn btn-warning disabled"; 
                }
                else if (sender == Kbtn)
                {
                    CheckLetter('k');
                    Kbtn.CssClass = "btn btn-warning disabled"; 
                }
                else if (sender == Lbtn)
                {
                    CheckLetter('l');
                    Lbtn.CssClass = "btn btn-warning disabled"; 
                }
                else if (sender == Mbtn)
                {
                    CheckLetter('m');
                    Mbtn.CssClass = "btn btn-warning disabled"; 
                }
                else if (sender == Nbtn)
                {
                    CheckLetter('n');
                    Nbtn.CssClass = "btn btn-warning disabled"; 
                }
                else if (sender == Obtn)
                {
                    CheckLetter('o'); 
                    Obtn.CssClass = "btn btn-warning disabled"; 
                }
                else if (sender == Öbtn)
                {
                    CheckLetter('ö');
                    Öbtn.CssClass = "btn btn-warning disabled"; 
                }
                else if (sender == Pbtn)
                {
                    CheckLetter('p');
                    Pbtn.CssClass = "btn btn-warning disabled"; 
                }
                else if (sender == Rbtn)
                {
                    CheckLetter('r');
                    Rbtn.CssClass = "btn btn-warning disabled"; 
                }
                else if (sender == Sbtn)
                {
                    CheckLetter('s');
                    Sbtn.CssClass = "btn btn-warning disabled"; 
                }
                else if (sender == Şbtn)
                {
                    CheckLetter('ş');
                    Şbtn.CssClass = "btn btn-warning disabled"; 
                }
                else if (sender == Tbtn)
                {
                    CheckLetter('t');
                    Tbtn.CssClass = "btn btn-warning disabled"; 
                }
                else if (sender == Ubtn)
                {
                    CheckLetter('u');
                    Ubtn.CssClass = "btn btn-warning disabled"; 
                }
                else if (sender == Übtn)
                {
                    CheckLetter('ü');
                    Übtn.CssClass = "btn btn-warning disabled"; 
                }
                else if (sender == Vbtn)
                {
                    CheckLetter('v');
                    Vbtn.CssClass = "btn btn-warning disabled"; 
                }
                else if (sender == Ybtn)
                {
                    CheckLetter('y');
                    Ybtn.CssClass = "btn btn-warning disabled"; 
                }
                else if (sender == Zbtn)
                {
                    CheckLetter('z');
                    Zbtn.CssClass = "btn btn-warning disabled"; 
                }
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('" + ex.Message + "');</script>");
            }

        }

        protected void BackBTN2_Click(object sender, EventArgs e)
        {
            Multiview.ActiveViewIndex = (Multiview.ActiveViewIndex - 2);
        }

        protected void RegameBTN_Click(object sender, EventArgs e)
        {
            NewGame();
        }
        protected void NewGame()
        {
            try
            {
                Timerlbl.Text = "60";   //reset countdown timer label to 60
                Timer.Enabled = true;   //start timer
                MaskWord.Font.Size = 72;
                getWord();
                lostCount = 0;  //reset lost count
                HangMan.Visible = false;    //hide hangman image
                //set letter buttons to enable
                Abtn.CssClass = "btn btn-outline-warning ";
                Bbtn.CssClass = "btn btn-outline-warning ";
                Cbtn.CssClass = "btn btn-outline-warning ";
                Çbtn.CssClass = "btn btn-outline-warning ";
                Dbtn.CssClass = "btn btn-outline-warning ";
                Ebtn.CssClass = "btn btn-outline-warning ";
                Fbtn.CssClass = "btn btn-outline-warning ";
                Gbtn.CssClass = "btn btn-outline-warning ";
                Ğbtn.CssClass = "btn btn-outline-warning ";
                Hbtn.CssClass = "btn btn-outline-warning ";
                Ibtn.CssClass = "btn btn-outline-warning ";
                İbtn.CssClass = "btn btn-outline-warning ";
                Jbtn.CssClass = "btn btn-outline-warning ";
                Kbtn.CssClass = "btn btn-outline-warning ";
                Lbtn.CssClass = "btn btn-outline-warning ";
                Mbtn.CssClass = "btn btn-outline-warning ";
                Nbtn.CssClass = "btn btn-outline-warning ";
                Obtn.CssClass = "btn btn-outline-warning ";
                Öbtn.CssClass = "btn btn-outline-warning ";
                Pbtn.CssClass = "btn btn-outline-warning ";
                Rbtn.CssClass = "btn btn-outline-warning ";
                Sbtn.CssClass = "btn btn-outline-warning ";
                Şbtn.CssClass = "btn btn-outline-warning ";
                Tbtn.CssClass = "btn btn-outline-warning ";
                Ubtn.CssClass = "btn btn-outline-warning ";
                Übtn.CssClass = "btn btn-outline-warning ";
                Vbtn.CssClass = "btn btn-outline-warning ";
                Ybtn.CssClass = "btn btn-outline-warning ";
                Zbtn.CssClass = "btn btn-outline-warning ";
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('" + ex.Message + "');</script>");
            }
        }


        #endregion


    }
}
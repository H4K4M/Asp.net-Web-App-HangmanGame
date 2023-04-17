<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="HW2.aspx.cs" Inherits="HW2.HW2" %>
<%-- Hakam Chedo 152120181096 --%>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>HangMan</title>
    <link href="https://cdn.jsdelivr.net/npm/bootswatch@5.2.3/dist/flatly/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" />

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js" integrity="sha384-w76AqPfDkMBDXo30jS1Sgez6pr3x5MlQ1ZAGC+nuZB+EYdgRZgiwxhTBTkF7CXvN" crossorigin="anonymous"></script>

    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Nunito&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.3/font/bootstrap-icons.css" />
</head>
<body background="images/Background.jpg" style="background-size: cover">
    <form id="form1" runat="server">
        <div class="d-flex justify-content-center" style="height: 100vh;">
            <div class="my-auto container">
                <asp:MultiView ID="Multiview" runat="server" ActiveViewIndex="0">
                    <%-- Main page --%>
                    <asp:View ID="ViewID0" runat="server">
                        <div class="row d-flex justify-content-center">
                            <img src="images/Hangmanlogo.png" style="width: 400px; background-color: rgb(103,140,127,0.5); border-radius: 50% 10% 10% 30%; border: solid 5px" />
                        </div>
                        <br />
                        <div class="row d-flex justify-content-center">
                            <asp:Button ID="StartBTN" CssClass="btn btn-success" runat="server" Text="Start" Width="200px" Height="100px" Font-Size="XX-Large" OnClick="StartBTN_Click" />
                        </div>
                        <br />
                        <div class="row d-flex justify-content-center">
                            <asp:Button ID="AddWordBTN" CssClass="btn btn-warning" runat="server" Text="Dictionary" Width="200px" Height="50px" OnClick="AddWordBTN_Click" />
                        </div>
                    </asp:View>
                    <%--  --%>
                    <%-- Dictionary page --%>
                    <asp:View ID="ViewID2" runat="server">
                        <div class="row " style="padding-left: 200px">
                            <asp:LinkButton ID="BackBTN" CssClass="btn btn-danger" Width="72px" OnClick="BackBTN_Click" runat="server"><i class="bi bi-x-square" style="font-size:36px;"></i></asp:LinkButton>
                        </div>
                        <br />
                        <div class="row d-flex justify-content-center">
                            <%-- Selected word --%>
                            <div class="col-md-2 card bg-light mb-3 justify-content-center" style="height: 200px">
                                <div class="row">
                                    <label class="form-label"><strong>Selected word:</strong></label>
                                    <div class="form-group d-flex flex-row align-items-center">
                                        <asp:TextBox CssClass="form-control" ID="SelectedwordTb" runat="server" AutoPostBack="true" ReadOnly="true" Style="cursor: default; resize: none" Height="100px" TextMode="MultiLine"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="form-group d-grid gap-2">
                                        <asp:Button CssClass="btn btn-danger disabled" ID="DeleteWordBTN" runat="server" Text="Delete selected word" OnClick="DeleteWordBTN_Click" />
                                    </div>
                                </div>
                            </div>
                            <%-- end Selected word --%>
                            <%-- List word --%>
                            <div class="col-md-2 d-flex justify-content-center">
                                <asp:ListBox ID="WordLsB" runat="server" OnSelectedIndexChanged="WordLsB_SelectedIndexChanged" AutoPostBack="true" Width="150px" Height="500px" BackColor="#E5DDC8" ForeColor="#DB1F48" Style="border: 5px solid #01949A; border-radius: 10px; padding: 10px;"></asp:ListBox>
                            </div>
                            <%-- end list word --%>
                            <%-- Add word --%>
                            <div class="col-md-2">
                                <div class="row card bg-light mb-3 justify-content-center" style="height: 300px">
                                    <%-- word --%>
                                    <div class="row ">
                                        <label class="form-label"><strong>New word:</strong></label>
                                        <div class="form-group d-flex flex-row align-items-center">
                                            <asp:TextBox CssClass="form-control" ID="AddWordTb" runat="server" onkeypress="return /^[a-zçğıöşü ]+$/i.test(event.key)" onpaste="return /^[a-zçğıöşü ]+$/i.test((event.clipboardData || window.clipboardData).getData('Text'))"></asp:TextBox>
                                            <asp:RequiredFieldValidator ControlToValidate="AddWordTb" runat="server" ErrorMessage="*" ForeColor="Red" ValidationGroup="add"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>
                                    <%-- end word --%>
                                    <br />
                                    <%-- Hint --%>
                                    <div class="row">
                                        <label class="form-label"><strong>New word's Hints:</strong></label>
                                        <div class="form-group d-flex flex-row align-items-center">
                                            <asp:TextBox CssClass="form-control" ID="HintTb" runat="server" Height="100px" TextMode="MultiLine" Style="resize: none;" onkeypress="return /^[a-zçğıöşü ]+$/i.test(event.key)" onpaste="return /^[a-zçğıöşü ]+$/i.test((event.clipboardData || window.clipboardData).getData('Text'))"></asp:TextBox>
                                            <asp:RequiredFieldValidator ControlToValidate="HintTb" runat="server" ErrorMessage="*" ForeColor="Red" ValidationGroup="add"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>
                                    <%-- end hint --%>
                                    <%-- btn --%>
                                    <div class="row">
                                        <div class="form-group d-grid gap-2">
                                            <asp:Button CssClass="btn btn-primary" ID="AddBTN" runat="server" Text="Add" ValidationGroup="add" OnClick="AddBTN_Click" />
                                        </div>
                                    </div>
                                    <%-- end btn --%>
                                </div> 
                                <asp:Panel ID="AlertPanel" CssClass="row alert alert-dismissible alert-success" runat="server" Visible="false">       
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                    <asp:Label ID="Statuslbl" runat="server" Text="" Font-Bold="true"></asp:Label>           
                                </asp:Panel>
                            </div>
                            <%-- end Add word --%>
                        </div>
                    </asp:View>
                    <%-- end Dictionary page --%>
                    <%-- Game page --%>
                    <asp:View ID="ViewID3" runat="server">
                        <%-- Buttons --%>
                        <div class="row ">
                            <div class="col">
                                <asp:LinkButton ID="BackBTN2" CssClass="btn btn-danger " Width="48px" runat="server" ToolTip="Main menu" OnClick="BackBTN2_Click"><i class="bi bi-door-open" style="font-size:24px; "></i></asp:LinkButton>
                            </div>
                            <div class="col d-flex justify-content-center">
                                <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
                                <asp:UpdatePanel ID="UpdatePanel" runat="server">
                                    <ContentTemplate>
                                        <asp:Label ID="Timerlbl" CssClass="bg-warning" Width="48px" Style="border-radius: 10px; padding: 10px" Font-Size="24px" runat="server" Text="60"></asp:Label>
                                        <asp:Timer ID="Timer" runat="server" Interval="1000" OnTick="Timer_Tick"></asp:Timer>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>
                            <div class="col d-flex justify-content-end">
                                <asp:LinkButton ID="RegameBTN" CssClass="btn btn-success" Width="48px" runat="server" ToolTip="Restart new game" OnClick="RegameBTN_Click"><i class="bi bi-arrow-clockwise" style="font-size:24px; "></i></asp:LinkButton>
                            </div>
                        </div>
                        <%-- end buttons --%>
                        <%-- Game --%>
                        <div class="row " style="height: 600px">
                            <%-- Hangman --%>
                            <div class="col-md-4 ">
                                <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                                    <ContentTemplate>
                                        <asp:ImageButton ID="HangMan" runat="server" Visible="false" />
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>
                            <%-- end Hangman --%>
                            <div class="col-md-1"></div>
                            <%-- gameplay --%>
                            <div class="col ">
                                <br />
                                <br />
                                <br />
                                <br />
                                <br />
                                <%-- Word --%>
                                <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                                    <ContentTemplate>
                                        <div class="row justify-content-center">
                                            <asp:Label ID="MaskWord" CssClass="form-control d-flex justify-content-center" runat="server" ForeColor="#C85250" Style="letter-spacing: 10px;" Font-Size="72px">___</asp:Label>
                                        </div>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                                <%-- end word --%>
                                <br />
                                <br />
                                <br />
                                <br />
                                <br />
                                <br />
                                <%-- hint --%>
                                <div class="row text-white bg-success" style="border-radius: 20px">
                                    <asp:Label ID="hintLbl" CssClass="d-flex  justify-content-center " runat="server" Font-Size="16px">Hint</asp:Label>
                                </div>
                                <%-- end hint --%>
                                <%-- Letters buttons --%>
                                <div id="Letters" class="row bg-primary justify-content-center" style="border-radius: 10px" runat="server">
                                    <asp:Button ID="Abtn" CssClass="btn btn-outline-warning p-2" Style="margin: 5px" Width="41.6px" runat="server" Text="A" OnClick="Letter_Click" />
                                    <asp:Button ID="Bbtn" CssClass="btn btn-outline-warning p-2" Style="margin: 5px" Width="41.6px" runat="server" Text="B" OnClick="Letter_Click" />
                                    <asp:Button ID="Cbtn" CssClass="btn btn-outline-warning p-2" Style="margin: 5px" Width="41.6px" runat="server" Text="C" OnClick="Letter_Click" />
                                    <asp:Button ID="Çbtn" CssClass="btn btn-outline-warning p-2" Style="margin: 5px" Width="41.6px" runat="server" Text="Ç" OnClick="Letter_Click" />
                                    <asp:Button ID="Dbtn" CssClass="btn btn-outline-warning p-2" Style="margin: 5px" Width="41.6px" runat="server" Text="D" OnClick="Letter_Click" />
                                    <asp:Button ID="Ebtn" CssClass="btn btn-outline-warning p-2" Style="margin: 5px" Width="41.6px" runat="server" Text="E" OnClick="Letter_Click" />
                                    <asp:Button ID="Fbtn" CssClass="btn btn-outline-warning p-2" Style="margin: 5px" Width="41.6px" runat="server" Text="F" OnClick="Letter_Click" />
                                    <asp:Button ID="Gbtn" CssClass="btn btn-outline-warning p-2" Style="margin: 5px" Width="41.6px" runat="server" Text="G" OnClick="Letter_Click" />
                                    <asp:Button ID="Ğbtn" CssClass="btn btn-outline-warning p-2" Style="margin: 5px" Width="41.6px" runat="server" Text="Ğ" OnClick="Letter_Click" />
                                    <asp:Button ID="Hbtn" CssClass="btn btn-outline-warning p-2" Style="margin: 5px" Width="41.6px" runat="server" Text="H" OnClick="Letter_Click" />
                                    <asp:Button ID="Ibtn" CssClass="btn btn-outline-warning p-2" Style="margin: 5px" Width="41.6px" runat="server" Text="I" OnClick="Letter_Click" />
                                    <asp:Button ID="İbtn" CssClass="btn btn-outline-warning p-2" Style="margin: 5px" Width="41.6px" runat="server" Text="İ" OnClick="Letter_Click" />
                                    <asp:Button ID="Jbtn" CssClass="btn btn-outline-warning p-2" Style="margin: 5px" Width="41.6px" runat="server" Text="J" OnClick="Letter_Click" />
                                    <asp:Button ID="Kbtn" CssClass="btn btn-outline-warning p-2" Style="margin: 5px" Width="41.6px" runat="server" Text="K" OnClick="Letter_Click" />
                                    <asp:Button ID="Lbtn" CssClass="btn btn-outline-warning p-2" Style="margin: 5px" Width="41.6px" runat="server" Text="L" OnClick="Letter_Click" />
                                    <asp:Button ID="Mbtn" CssClass="btn btn-outline-warning p-2" Style="margin: 5px" Width="41.6px" runat="server" Text="M" OnClick="Letter_Click" />
                                    <asp:Button ID="Nbtn" CssClass="btn btn-outline-warning p-2" Style="margin: 5px" Width="41.6px" runat="server" Text="N" OnClick="Letter_Click" />
                                    <asp:Button ID="Obtn" CssClass="btn btn-outline-warning p-2" Style="margin: 5px" Width="41.6px" runat="server" Text="O" OnClick="Letter_Click" />
                                    <asp:Button ID="Öbtn" CssClass="btn btn-outline-warning p-2" Style="margin: 5px" Width="41.6px" runat="server" Text="Ö" OnClick="Letter_Click" />
                                    <asp:Button ID="Pbtn" CssClass="btn btn-outline-warning p-2" Style="margin: 5px" Width="41.6px" runat="server" Text="P" OnClick="Letter_Click" />
                                    <asp:Button ID="Rbtn" CssClass="btn btn-outline-warning p-2" Style="margin: 5px" Width="41.6px" runat="server" Text="R" OnClick="Letter_Click" />
                                    <asp:Button ID="Sbtn" CssClass="btn btn-outline-warning p-2" Style="margin: 5px" Width="41.6px" runat="server" Text="S" OnClick="Letter_Click" />
                                    <asp:Button ID="Şbtn" CssClass="btn btn-outline-warning p-2" Style="margin: 5px" Width="41.6px" runat="server" Text="Ş" OnClick="Letter_Click" />
                                    <asp:Button ID="Tbtn" CssClass="btn btn-outline-warning p-2" Style="margin: 5px" Width="41.6px" runat="server" Text="T" OnClick="Letter_Click" />
                                    <asp:Button ID="Ubtn" CssClass="btn btn-outline-warning p-2" Style="margin: 5px" Width="41.6px" runat="server" Text="U" OnClick="Letter_Click" />
                                    <asp:Button ID="Übtn" CssClass="btn btn-outline-warning p-2" Style="margin: 5px" Width="41.6px" runat="server" Text="Ü" OnClick="Letter_Click" />
                                    <asp:Button ID="Vbtn" CssClass="btn btn-outline-warning p-2" Style="margin: 5px" Width="41.6px" runat="server" Text="V" OnClick="Letter_Click" />
                                    <asp:Button ID="Ybtn" CssClass="btn btn-outline-warning p-2" Style="margin: 5px" Width="41.6px" runat="server" Text="Y" OnClick="Letter_Click" />
                                    <asp:Button ID="Zbtn" CssClass="btn btn-outline-warning p-2" Style="margin: 5px" Width="41.6px" runat="server" Text="Z" OnClick="Letter_Click" />
                                </div>
                                <%-- end letters buttons --%>
                            </div>
                            <%-- end gameplay --%>
                        </div>
                    </asp:View>
                    <%-- end game page --%>
                </asp:MultiView>
            </div>
        </div>
    </form>
    <style>
</style>
</body>
</html>

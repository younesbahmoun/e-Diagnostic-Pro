<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<c:set var="registerPage" value="${false}" />
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="theme-color" content="#000000">
    <meta name="description" content="Connectez-vous à TéléExpertise, votre espace de collaboration entre professionnels de santé.">
    <title>Connexion — TéléExpertise</title>
    <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/assets/favicon.svg">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/auth.css">
    <script src="${pageContext.request.contextPath}/assets/js/auth.js" defer></script>
</head>
<body class="login-page">
    <a class="skip-link" href="#auth-form">Aller au formulaire de connexion</a>
    <%@ include file="fragments/auth-icons.jspf" %>
    <div class="page-shell">
        <%@ include file="fragments/auth-header.jspf" %>
        <main>
            <div class="page-heading"><p class="eyebrow">Votre espace de soin</p><span class="page-index">CONNEXION / 01</span></div>
            <div class="auth-layout">
                <%@ include file="fragments/auth-bento.jspf" %>
                <section class="auth-card" aria-labelledby="auth-title">
                    <nav class="auth-tabs" aria-label="Authentification">
                        <a class="auth-tab" href="${pageContext.request.contextPath}/login" aria-current="page">Connexion</a>
                        <a class="auth-tab" href="${pageContext.request.contextPath}/register">Inscription</a>
                    </nav>
                    <div class="form-intro">
                        <p class="form-eyebrow"><svg class="icon" aria-hidden="true"><use href="#icon-lock"/></svg> Espace professionnel</p>
                        <h1 class="form-title" id="auth-title">Heureux de vous<br>retrouver.</h1>
                        <p class="form-description">Votre équipe et vos patients vous attendent.<br>Connectez-vous pour reprendre le fil.</p>
                    </div>
                    <c:if test="${param.success eq 'registered' and empty errorMessage}">
                        <div class="alert alert-success" role="status" tabindex="-1" data-auth-feedback>
                            <svg class="icon" aria-hidden="true"><use href="#icon-check"/></svg>
                            <p><strong>Bienvenue dans le collectif.</strong>Votre compte a été créé. Vous pouvez vous connecter.</p>
                        </div>
                    </c:if>
                    <c:if test="${not empty errorMessage}">
                        <div class="alert" role="alert" tabindex="-1" data-auth-feedback>
                            <svg class="icon" aria-hidden="true"><use href="#icon-info"/></svg>
                            <p><strong>Connexion impossible</strong><c:out value="${errorMessage}" /></p>
                        </div>
                    </c:if>
                    <form class="auth-form" id="auth-form" action="${pageContext.request.contextPath}/login" method="post" accept-charset="UTF-8" data-auth-form>
                        <div class="field">
                            <label class="field-label" for="email">Adresse e-mail professionnelle</label>
                            <div class="input-wrap">
                                <svg class="icon" aria-hidden="true"><use href="#icon-mail"/></svg>
                                <input class="field-input" type="email" id="email" name="email" placeholder="vous@etablissement.ma" value="${fn:escapeXml(param.email)}" autocomplete="username" maxlength="150" spellcheck="false" autocapitalize="none" required>
                            </div>
                        </div>
                        <div class="field">
                            <label class="field-label" for="password">Mot de passe</label>
                            <div class="input-wrap">
                                <svg class="icon" aria-hidden="true"><use href="#icon-lock"/></svg>
                                <input class="field-input" type="password" id="password" name="password" placeholder="Votre mot de passe" autocomplete="current-password" required>
                                <button class="password-toggle" type="button" aria-label="Afficher le mot de passe" aria-controls="password" aria-pressed="false" data-password-toggle hidden>
                                    <svg class="icon" aria-hidden="true"><use href="#icon-eye"/><path class="eye-slash" d="m3 3 18 18"/></svg>
                                </button>
                            </div>
                        </div>
                        <button class="submit-button" type="submit" data-loading-label="Connexion en cours…"><span data-submit-label>Se connecter</span><svg class="icon" aria-hidden="true"><use href="#icon-arrow"/></svg></button>
                    </form>
                    <p class="form-switch">Pas encore de compte ? <a href="${pageContext.request.contextPath}/register">Rejoindre le collectif</a></p>
                    <p class="form-footnote"><svg class="icon" aria-hidden="true"><use href="#icon-shield"/></svg> Un espace réservé aux professionnels de santé.</p>
                </section>
            </div>
        </main>
        <%@ include file="fragments/auth-footer.jspf" %>
    </div>
</body>
</html>

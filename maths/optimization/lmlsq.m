function [x_res, x_iter, f_iter, cnt] = lmlsq(fun, x0, varargin)
% LMLSQ The Levenberg-Marquardt method for optimization
% fun - The function to be optimized. In fact, the cost function is
% F(x)=0.5*fun(x)'*fun(x).
% x0 - The initial x for iteration.
% There are some option parameters:
% jacobian - The analytical jacobian matrix. If no analytical jacobian
% matrix inputed, we use numeric finite jacobian matrix. Default: no
% analytical jacobian matrix.
% maxIter - The maximum number of iterations for calculate the result.
% Default: 100.
% tao - The factor used to initialize u. Default:0.001.
% ks1 - Used to judge if the gradient small enough to stop iteration.
% ks2 - Used to judge if x change is small enought to stop iteration.

% output:
% x_res - The result for optimization.
% x_iter - Record x for every iteration.
% f_iter - Record fun value for every iteration.
% cnt - The number of changes x.
% k - The number of total iterations.

%Reference: K. Madsen, H.B. Nielson etc."Method for nonlinear least squares problems"
%  Created by  Shen Quanmin on 2019/03/10.

    maxiter = 100;
    tao = 0.001;
    ks1 = 1e-7;
    ks2 = 1e-7;
    jac = 0;
    analyze_jac = false;
    
    opt_num = nargin - 2;
    if opt_num > 0
        for i = 1:opt_num-1
            name = varargin{i}; 
            value = varargin{i+1};
            if strcmp(name, 'jacobian')
                jac = value;
                analyze_jac = true;
            elseif strcmp(name, 'maxIter')
                maxiter = value;
            elseif strcmp(name, 'tao')
                tao = value;
            elseif strcmp(name, 'ks1')
                ks1 =value;
            elseif strcmp(name, 'ks2')
                ks2 = value;
            else
                disp(['Unknow parameter name: ', name]);
            end
        end
    end
    
    ks1_sq = ks1*ks1;
    ks2_sq = ks2*ks2;
    k = 1;
    v = 2;
    x = x0;
    delta = ones(size(x))*1e-7;
    f = feval(fun, x);
    if analyze_jac
        j = feval(jac, x);
    else
        j = jacobian_eval(fun, f, x, delta);
    end
    A = j'*j;
    g = j'*f;
    found = (max(g)<=ks1_sq);
    u = tao * max(diag(A));
    I = eye(size(j,2),size(j,2));
    
    temp = 1/3;
    
    x_res = x0;
    x_iter = zeros(size(x0,1),maxiter);
    x_iter(:,1) = x0;
    f_iter = zeros(size(f,1),maxiter);
    f_iter(:,1) = f;
    cnt = 1;
    
    while (~found) && k < maxiter
        k = k+1;
        h = -(A+u*I)\g;
        if h'*h <= ks2_sq*(x'*x+ks2_sq)
            found = true;
        else
            xnew = x + h;
            fnew = feval(fun, xnew);
            pro = (f'*f-fnew'*fnew)/(h'*(u*h-g));
            if pro > 0
                x = xnew;
                if analyze_jac
                    j = feval(jac, x);
                else
                    j = jacobian_eval(fun, fnew, x, delta);
                end
                A = j'*j;
                g = j'*fnew;
                found = (max(g)<=ks1_sq);
                u = u * max(temp, 1-(2*pro-1)^3);
                v = 2;
                
                cnt = cnt+1;
                x_iter(:,cnt) = x;
                x_res = x;
                f_iter(:,cnt) = fnew;
            else
                u = u*v;
                v = 2*v;
            end
        end
    end
end

function jac_value = jacobian_eval(fun, fun_x_val, x, delta)
% numerical approximation to Jacobi matrix

    delta(delta==0) = eps;
    jac_value = zeros(size(x,1),size(fun_x_val,1));
    for i = 1:size(x,1)
        xd = x;
        xd(i) = xd(i) + delta(i);
        fun_x_new = feval(fun, xd);
        dy = fun_x_new - fun_x_val;
        jac_value(:,i) = dy/delta(i);
    end
end